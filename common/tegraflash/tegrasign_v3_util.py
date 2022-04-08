from __future__ import print_function

#
# Copyright (c) 2018-2021, NVIDIA Corporation.  All Rights Reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#

import binascii
import json
import math
import struct
import os, sys
import subprocess
import re
import time
import traceback
import yaml

AES_128_HASH_BLOCK_LEN = 16
AES_256_HASH_BLOCK_LEN = 16

NV_RSA_MAX_KEY_SIZE = 512
NV_COORDINATE_SIZE  = 64

NV_ECC_SIG_STRUCT_SIZE = 96
NV_ECC521_SIG_STRUCT_SIZE = 136
ED25519_KEY_SIZE = 32
ED25519_SIG_SIZE = 64
XMSS_KEY_SIZE = 132

MAX_KEY_LIST = 3

# Mode Defines
NvTegraSign_FSKP    = 'FSKP'
NvTegraSign_SBK     = 'SBK'
NvTegraSign_PKC     = 'PKC'
NvTegraSign_ECC     = 'ECC'
NvTegraSign_ED25519 = 'EDDSA'
NvTegraSign_XMSS    = 'XMSS'

TegraOpenssl = 'tegraopenssl'

class ReadFlag:
    IGNORE  = 1
    ENFORCE = 2

class KdfType:
     CBC     = 0
     GCM     = 1

class KeyType:
    SBK     = 'SBK'
    KEK0    = 'KEK0'
    FSKP_AK = 'FSKP_AK'
    FSKP_EK = 'FSKP_EK'
    FSKP_KDK= 'FSKP_KDK'
    FSKP    = 'FSKP'
    PKC     = 'PKC'
    ED25519 = 'EDDSA'
    HSM     = 'HSM'     # This is for --key not defined
    UNKNOWN = 'UNKNOWN' # This is default init

class Token:
    def __init__(self, arr = None):
        self.buf = arr
        self.filename = None
        if (arr != None):
           self.buf = str_to_hex(arr) # Set the default value

    def parse(self, arg, is_str = True):
        if '=' in arg:
            # Format: context=context.bin
            sublist = arg.split('=')
            self.read(sublist[1])
        else:
            # Format: expect string in
            self.buf = str_to_hex(arg)

    def read(self, filename, flag = ReadFlag.ENFORCE):
        if (filename == None) and (flag == ReadFlag.IGNORE):
            return                    # Assume default value
        with open_file(filename, 'rb') as f:
            self.buf = f.read()
            self.filename = filename
    def set_buf(self, hexbuf):
        self.buf = hexbuf

    def get_hexbuf(self):
        return self.buf

    def get_strbuf(self):
        if self.buf == None:
            return None
        return hex_to_str(self.buf)

class PkcKey:
    def __init__(self):
        self.Sha = Sha._256
        self.PkcsVersion = 0
        self.PubKey = bytearray(NV_RSA_MAX_KEY_SIZE + 1)
        self.PrivKey = bytearray(NV_RSA_MAX_KEY_SIZE + 1)
        self.P = bytearray(NV_RSA_MAX_KEY_SIZE)
        self.Q = bytearray(NV_RSA_MAX_KEY_SIZE)

class ECKey:
    def __init__(self):
        self.PrivKey = 1
        self.Coordinate = bytearray(NV_COORDINATE_SIZE)

class EDKey:
    def __init__(self):
        self.PrimeD = bytearray(ED25519_KEY_SIZE)
        self.PubKey = bytearray(ED25519_KEY_SIZE)

class HSM:
    def __init__(self):
        self.type = KeyType.UNKNOWN
        self.algo_only = False

    def parse(self, arg_list, mode):
        # Take the mode as type when hsm is not explicitly defined
        if (arg_list == None) or (len(arg_list) == 0):
            self.type = mode
            return
        # Parse the hsm flag for the mode explicitly
        for arg in arg_list:
            arg = arg.upper()
            if KeyType.FSKP_AK in arg:
                self.type = KeyType.FSKP_AK
            elif KeyType.FSKP_EK in arg:
                self.type = KeyType.FSKP_EK
            elif KeyType.FSKP_KDK in arg:
                self.type = KeyType.FSKP_KDK
            elif KeyType.FSKP in arg:
                self.type = KeyType.FSKP
            elif KeyType.KEK0 in arg:
                self.type = KeyType.KEK0
            elif KeyType.SBK in arg:
                self.type = KeyType.SBK
            elif 'RSA' in arg:
                self.type = KeyType.PKC
            elif KeyType.ED25519 in arg:
                self.type = KeyType.ED25519
            elif 'ALGO' in arg:
                self.algo_only = True
            else:
                raise tegrasign_exception('Unknown HSM type parsed: ' + arg)

    def get_type(self):
        return self.type

    def is_algo_only(self):
        return self.algo_only

    def is_fskp_mode(self):
        return self.type in [KeyType.FSKP_AK, KeyType.FSKP_EK, KeyType.FSKP_KDK, KeyType.FSKP]

class KDF:
    def __init__(self):
        self.iv = Token('00000000000000000000000000000000') #Set default value
        self.aad = Token()
        self.tag = Token()
        self.verify = 0
        self.label = Token()
        self.bl_label = Token()
        self.fw_label = Token()
        self.context = Token()
        self.chipid = ''
        self.magicid = ''
        self.type = KdfType.CBC
        self.msg = None

    def parse_file(self, p_key, arg, internal):
        kdf_file = arg.split('=')[1]

        with open(kdf_file) as f:
            params = yaml.safe_load(f)

        tokens = {'IV':'--iv', 'AAD':'--aad', 'VER':None, 'DERSTR':None, 'CHIPID':None,
                  'MAGICID':None, 'FLAG':None, 'BL_DERSTR':None, 'FW_DERSTR':None}
        for token in tokens:
            if token in params:
                # Update the entries if they are found in internal dict
                if tokens.get(token) in internal:
                    internal[tokens.get(token)] = params.get(token)
                if token == 'AAD':
                    self.aad.parse(params.get(token))
                elif token == 'CHIPID':
                    self.chipid = params.get(token)
                elif token == 'FLAG':
                    self.flag = DerKey.SBK_PT if params.get(token).upper() == 'SBK_PT' else DerKey.SBK_WRAP
                elif token == 'VER':
                    self.context.parse(params.get(token))
                elif token == 'IV':
                    if params.get(token).lower() != 'random': # Will generate random iv later
                        self.iv.parse(params.get(token))
                elif token == 'DERSTR':
                    self.label.parse(params.get(token))
                elif token == 'BL_DERSTR':
                    self.bl_label.parse(params.get(token))
                elif token == 'FW_DERSTR':
                    self.fw_label.parse(params.get(token))
                elif token == 'MAGICID':
                    self.magicid = params.get(token)

        p_key.src_file = internal['--file']
        p_key.filename = internal['--key']
        p_key.mode = NvTegraSign_FSKP
        if internal['--hsm']:
            p_key.hsm.type == KeyType.FSKP
        else:
            p_key.hsm.type == KeyType.UNKNOWN
        internal["--enc"] = 'aesgcm'
        self.type = KdfType.GCM
        p_key.key.aeskey = str_to_hex('0123456789abcdef0123456789abcdef') # Preset so not to skip enc when doing is_zero_aes check

    def parse(self, p_key, internal):
        kdf_arg = internal['--kdf']
        # Format: ['context=context.bin', 'label=label.bin']
        for arg in kdf_arg:
            arg_low = arg.lower()
            if 'context=' in arg_low:
                self.context.parse(arg)
            elif 'label=' in arg_low:
                self.label.parse(arg)
            elif 'kdf_file=' in arg_low:
                self.parse_file(p_key, arg, internal)
            else:
                raise tegrasign_exception('Unknown argument parsed ' + arg)

    def get_hexmsg(self):
        return str_to_hex(self.msg)

    def get_composed_msg(self, L, hex_label, hex_context=True):
        fixed_msg = ''
        # Append Label
        if self.label.get_hexbuf() is not None:
            if hex_label is True:
                fixed_msg = self.label.get_hexbuf()
            else:
                fixed_msg = self.label.get_strbuf()
        # Append '00' byte
        fixed_msg += '00'
        # Append Context
        if len(self.context.get_hexbuf()) == 0:
            fixed_msg += '00'
        else:
            if hex_context is True:
                fixed_msg += self.context.get_hexbuf()
            else:
                fixed_msg += self.context.get_strbuf()
        # Append 'L' bit string (byte aligned)
        Lbits = '%08x' % L
        fixed_msg += Lbits if len(Lbits) % 2 == 0 else '0' + Lbits

        rlen = 32
        self.msg = compose_msg_data(CtrLoc.BEFORE, compose_ctr(rlen, 1), fixed_msg)


class Key:
    def __init__(self):
        self.eckey = ECKey()
        self.edkey = EDKey()
        self.pkckey = PkcKey()
        self.aeskey = bytearray(16)

class Sha:
    _512 = 1
    _256 = 0

class DerKey:
    DEV            = '1'
    NV             = '2'
    DEVPDS         = '3'
    NVPDS          = '4'
    SBK_PT         = '5'
    SBK_WRAP       = '6'

class KdfArg:
    IV     = 0
    AAD    = 1
    TAG    = 2
    SRC    = 3
    FLAG   = 4
    DKSTR  = 5 # derivation string for DK
    DKVER  = 6 # version for DK
    BLSTR  = 7 # derivation label for BL_(DEC)_KDK
    FWSTR  = 8 # derivation label for FW_(DEC)_KDK

class SignKey:
    def __init__(self):
        self.mode = "Unknown"
        self.filename = "Unknown"
        self.key = Key()
        self.keysize = 16
        self.kdf = KDF()
        self.hsm = HSM()
        self.len = 0
        self.off = 0
        self.src_file = None
        self.src_buf = None
        self.src_size = 0

    def parse_hsm(self, hsm, mode):
        self.hsm.parse(hsm, mode)

    def parse(self, src_file, length, offset):
        self.src_file = src_file
        (self.src_buf, self.src_size, self.len, self.off) = check_len_off(src_file, length, offset)

    def validate_hsmmode(self):
        if (self.hsm.type == self.mode):
            return
        # SBK and KEK0 are considered the same mode
        if (self.hsm.type in [KeyType.SBK, KeyType.KEK0]) and (self.mode == NvTegraSign_SBK):
            return

        # FSKP* are considered the same mode
        if (self.hsm.type in [KeyType.FSKP_AK, KeyType.FSKP_EK, KeyType.FSKP_KDK, KeyType.FSKP]) and (self.mode == NvTegraSign_FSKP):
            return

        if (self.hsm.algo_only):
            return
        raise tegrasign_exception('HSM mode ' + self.hsm.type + ' specified does not match --key mode type ' + self.mode)

    def get_sign_buf(self):
        return self.src_buf[self.off : self.off + self.len]

class tegrasign_exception(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)

AAD_0_96 = ('00' * 12)

def xor_hex(a, b):
    if len(a) > len(b):
        return "".join(["%x" % (int(x,16) ^ int(y,16)) for (x, y) in zip(a[:len(b)], b)])
    else:
        return "".join(["%x" % (int(x,16) ^ int(y,16)) for (x, y) in zip(a, b[:len(a)])])

def manifest_xor_offset(manifest, offset):
    if len(manifest) < len(offset):
        raise tegrasign_exception('Invalid Manifest length %d < Offset length %d ' % (len(manifest), len(offset)))
    return xor_hex(manifest[:len(offset)], offset) + manifest[len(offset):]

'''
Enumerate for Counter location: Before/Middle/After
'''
class CtrLoc:
    BEFORE = 1
    MIDDLE = 2
    AFTER = 3

def compose_ctr(rlen, i):
    if rlen == 8:
        return ('%02x' % i)
    elif rlen == 16:
        return ('%04x' % i)
    elif rlen == 24:
        return ('%06x' % i)
    else:
        return ('%08x' % i)

def compose_msg_data(order, cntr, data):
    if order == CtrLoc.BEFORE:
        return cntr + data
    elif order == CtrLoc.AFTER:
        return data + cntr
    else:
        raise tegrasign_exception('Counter location in the middle of input message is not implemented yet!')

def get_composed_msg(label, ctx, L, hex_label, hex_context=True):
    fixed_msg = ''
    # Append Label
    if label is not None:
        if hex_label is True:
            fixed_msg = label
        else:
            fixed_msg = literal_to_hex(label)
    # Append '00' byte
    fixed_msg += '00'
    # Append Context
    if len(ctx) == 0:
        fixed_msg += '00'
    else:
        if hex_context is True:
            fixed_msg += ctx
        else:
            fixed_msg += literal_to_hex(ctx) #ctx.encode('utf-8').hex()
    # Append 'L' bit string (byte aligned)
    Lbits = '%08x' % L
    fixed_msg += Lbits if len(Lbits) % 2 == 0 else '0' + Lbits

    rlen = 32
    return compose_msg_data(CtrLoc.BEFORE, compose_ctr(rlen, 1), fixed_msg)

cmd_environ = { }
start_time = time.time()
is_standalone = False
is_verbose = False
is_hsm_on = False
script_dir= os.path.dirname(os.path.realpath(__file__)) + os.sep
bin_dir = script_dir
pid = str(os.getpid())

def isPython3():

    if sys.hexversion >= 0x3000000:
        return True

    return False

'''
If use_verbose is True and '--verbose' is set, then proceed to:
If tegrasign is invoked as standalone, do default print
Else it prints timestamp, to be aligned with tegraflash
'''
def info_print(string, use_verbose=False):
    global is_verbose
    if use_verbose and is_verbose == False:
        return
    if is_standalone:
        print('%s' %(string))
    else:
        diff_time = time.time() - start_time
        print('[ %8.4f ] %s' % (diff_time, string))

def print_process(process, capture_log = False):

    print_time = True
    diff_time = time.time() - start_time
    log = ''

    while process.poll() is None:
        output = process.stdout.read(1)
        if capture_log:
            log += output.decode("utf-8")
        outputchar = output.decode('ascii')

        if outputchar == '\n' :
            diff_time = time.time() - start_time
            print_time = True
        elif outputchar == '\r' :
            print_time = True
        elif outputchar:
            if print_time and not is_standalone:
                print('[ %8.4f ] ' % diff_time, end='')
                print_time = False

        sys.stdout.write(outputchar)
        sys.stdout.flush()

    for string in process.communicate()[0].decode('utf-8').split('\n'):
        if capture_log and len(string) > 0:
            log += str(string)
            # In case if timestamp is already printed above, it's skipped here.
            if print_time == False:
                print('%s' %(string))
                print_time = True
            else:
                info_print(string)

    return log

def set_env(standalone, verbose, hsm = False, path = None):
    if standalone:
        global cmd_environ
        local_env = os.environ
        local_env["PATH"] += os.pathsep + os.path.dirname(os.path.realpath(__file__))
    else:
        # Delay import to avoid import clash
        from tegraflash_internal import cmd_environ
        local_env = cmd_environ
        # Check to see if signing is invoked by GVS and set env var for XMSS
        if ('TEST_LOG_DIR' in local_env) and 'vrl' in local_env['TEST_LOG_DIR']:
            local_env['XMSS_SIGN_CHECK_KEY_PERMISSION'] = 'no'
    # Add the file location to the $PATH
    if 'PATH' in local_env:
        local_env['PATH'] += os.pathsep + os.path.dirname(os.path.realpath(__file__))
    cmd_environ = local_env

    global is_standalone
    is_standalone = standalone

    global is_verbose
    is_verbose = verbose

    global is_hsm_on
    is_hsm_on = hsm

    if path != None:
        global bin_dir
        bin_dir = path

'''
Returns the flag indicating HSM mode or not
'''
def is_hsm():
    global is_hsm_on
    return is_hsm_on

def run_command(cmd, enable_print=True):

    log = ''
    if is_verbose == True:
        info_print(' '.join(cmd))

    use_shell = (sys.platform == 'win32')

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=use_shell, env=cmd_environ)

    if enable_print == True:
        log = print_process(process, enable_print)
    return_code = process.wait()
    if return_code != 0:
        raise tegrasign_exception('Return value = ' + str(return_code) +
                ' . Command = ' + ' '.join(cmd))

    return log

'''
Master exit routine to terminate tegrasign.
'''
def exit_routine():
    info_print ('********* Error. Quitting. *********')
    global is_standalone
    if is_standalone:
        sys.exit(1)
    else:
        return 1
'''
Find the file in the searchable paths
'''
def search_file(filename):
    path_list = os.getenv("PATH").split(os.pathsep)
    for path in path_list:
        file_path = os.path.join(path, filename)
        if os.path.isfile(file_path):
            return file_path
    return filename

'''
Opens a file and returns a file handle or None if fail
'''
def open_file(file_name, attrib):
    file_handle = None

    try:
        file_handle = open(file_name,attrib)
    except IOError:
        info_print("Cannot open %s with attribute %s\n" %(file_name,attrib))
        exit_routine()

    return file_handle

'''
Write data to given file handle
'''
def write_file(file_handle, data):
    try:
        file_handle.write(data)
    except IOError:
        info_print("Cannot write %s \n" %(file_name))

'''
Executes the path of the binary that is found
'''
def exec_file(name):
    bin_name = name
    if sys.platform in {'win32', 'cygwin'}:
        bin_name = name + '.exe'

    if not os.path.isfile(bin_name):
        bin_name = bin_dir + bin_name
        if not os.path.isfile(bin_name):
            raise tegrasign_exception('Could not find ' + bin_name)
    return [bin_name]

'''
Checks to see if filename is a file, if it is not, prints warning msg
'''
def check_file(filename):
    if not os.path.isfile(filename):
        info_print('Warning: %s is not found' %(filename))
        return False

    return True

'''
Returns a str for the given mode. For xml tag, zerosbk and sbk both returns 'sbk'
For mode.txt, zerosbk will return 'zerosbk' instead of 'sbk'
'''
def get_mode_str(pKey, is_modetxt):
    if pKey.mode == NvTegraSign_PKC:
        mode_str = 'pkc'
    elif pKey.mode == NvTegraSign_ECC:
        mode_str = 'ec'
    elif pKey.mode == NvTegraSign_ED25519:
        mode_str = 'eddsa'
    elif pKey.mode == NvTegraSign_XMSS:
        mode_str = 'xmss'
    else:
        if (is_modetxt and is_zero_aes(pKey)):
            mode_str = 'zerosbk'
        else:
            mode_str = 'sbk'

    return mode_str

'''
Returns a byte array specified by n size using the input value
'''
def int_2bytes(n, val):
    n=int(n)
    val=int(val)
    arr = bytearray(int(n))
    for i in range(n-1):
        arr[i] = val & 0xFF
        val >>= 8

    arr[n-1] = val & 0xFF

    return bytes(arr)

'''
Returns the number of bytes for the given integer
'''
def int_2byte_cnt(val):
    val = int(val)
    h = hex(val)
    n_cnt = len(str(h)) - 2 # account for '0x'

    if (n_cnt %2 == 0):
        return n_cnt/2

    return n_cnt/2 + 1

'''
Checks the return string to make sure it does contain: 'Valid'
'''
def is_ret_ok(ret_str):

    if "Valid" in ret_str or "Key size is " in ret_str:
        return True
    return False


'''
Checks to see if the given aes key is a string of zeros or not
'''
def is_zero_aes(p_key):
    if is_hsm():
        from tegrasign_v3_hsm import is_zero_aes_hsm
        return is_zero_aes_hsm(p_key)

    for b in p_key.key.aeskey:
        if b != 0:
            return False

    return True

'''
Swap a mutable bytearray into little-endian format that Tegra expects
'''
def swapbytes(a):

    n = len(a)
    if n % 4 != 0:
        return None

    for i in range(0, int(n/2)):
        a[i], a[n-i-1] = a[n-i-1], a[i]

    return a

'''
Convert hex string to hex array
'''
def str_to_hex(text):
    if(isPython3()):
        hex_arr = binascii.unhexlify(text.strip())
    else:
        hex_arr = text.strip().decode("hex")
    return hex_arr

'''
Convert literal to hex array
'''
def literal_to_hex(literal):
    if(isPython3()):
        hex_arr = literal.encode('utf-8').hex()
    else:
        hex_arr = literal.strip().encode("hex")
    return hex_arr

'''
Convert hex array to string
'''
def hex_to_str(arr):
    return binascii.hexlify(arr).decode("utf8")

'''
Check length and offset of the file
'''
def check_len_off(filename, length, offset):
    with open(filename, 'rb') as f:
        file_buf = bytearray(f.read())
        file_size = len(file_buf)

    if (type(length) == str):
        length = int(length)

    if (type(offset) == str):
        offset = int(offset)

    length = length if length > 0 else file_size - offset
    offset = offset if offset > 0 else 0

    if file_size < offset:
        length = 0
        info_print('Warning: Offset %d is more than file Size %d for %s' % (offset, file_size, filename))
        exit_routine()

    if (offset + length) > file_size:
        info_print('Warning: Offset %d + Length %d is greater than file Size %d for %s' % (offset, length, file_size, filename))
        exit_routine()

    return (file_buf, file_size, length, offset)

'''
   verify_opt: if = 1 to decrypt the buffer
                  = 0 means no verify/decryption involved
               if is a str type, indicades a file path, then decrypt the file and compare with original
'''
def do_aes_gcm(buff_to_enc, length, p_key, iv, aad, tag, verify_opt, verbose):
    if is_hsm():
        from tegrasign_v3_hsm import do_aes_gcm_hsm
        return do_aes_gcm_hsm(buff_to_enc, p_key)
    base_name = script_dir + 'v3_gcm_' + pid
    raw_name = base_name + '.raw'
    result_name = base_name + '.out'
    # check tag and verify_file are both defined
    if (type(tag) == int and type(verify_opt) == str):
        raise tegrasign_exception('--tag and --verify must both be specified')

    raw_file = open_file(raw_name, 'wb')

    key_bytes = len(binascii.hexlify(p_key.key.aeskey))/2
    keysize_bytes = int_2byte_cnt(p_key.keysize)
    len_bytes = int_2byte_cnt(length)
    enc_bytes = len(buff_to_enc)
    dest_bytes = int(length)
    result_bytes = len(result_name) + 1
    if (type(iv) == type(None)):
        iv_bytes = 0
    else:
        iv_bytes = len(binascii.hexlify(iv))/2
    if (isinstance(aad, int)):
        aad_bytes = 0
    else:
        aad_bytes = len(binascii.hexlify(aad))/2

    if (isinstance(tag, int)):
        tag_bytes = 0
    else:
        tag_bytes = len(binascii.hexlify(tag))/2

    if (type(verify_opt) == int):
        verify_bytes = verify_opt
    else:
        verify_bytes = len(verify_opt) + 1

    buff_dest = "0" * dest_bytes

    # to write to file
    # order: sizes then data for: key, length, buff_to_enc, buff_dest, result_name, iv, aad, tag, file

    num_list = [key_bytes, keysize_bytes, len_bytes, enc_bytes, dest_bytes, result_bytes, iv_bytes, aad_bytes, tag_bytes, verify_bytes]
    for num in num_list:
        arr = int_2bytes(4, num)
        write_file(raw_file, arr)

    write_file(raw_file, p_key.key.aeskey)
    arr = int_2bytes(keysize_bytes, p_key.keysize)
    write_file(raw_file, arr)
    arr = int_2bytes(len_bytes, length)
    write_file(raw_file, arr)
    write_file(raw_file, bytes(buff_to_enc))
    write_file(raw_file, buff_dest.encode("utf-8"))
    write_file(raw_file, result_name.encode("utf-8"))
    nullarr = bytearray(1)
    nullarr[0] = 0          # need this null for char*
    write_file(raw_file, nullarr)
    if iv_bytes > 0:
        write_file(raw_file, bytes(iv))
    if aad_bytes > 0:
        write_file(raw_file, bytes(aad))
    if tag_bytes > 0:
        write_file(raw_file, bytes(tag))
    if verify_bytes > 0:
        write_file(raw_file, verify_opt.encode("utf-8"))
        nullarr = bytearray(1)
        nullarr[0] = 0          # need this null for char*
    raw_file.close()

    command = exec_file(TegraOpenssl)
    command.extend(['--aesgcm', raw_name])
    if (verbose != 0):
        command.extend(['--verbose'])

    ret_str = run_command(command)
    if (isinstance(tag, int) == False) and (type(verify_opt) == str):
        info_print ('********* Verification complete. Quitting. *********')
        sys.exit(1)

    else:
        if check_file(result_name):
            result_fh = open_file(result_name, 'rb')
            buff_sig = result_fh.read() # Return data to caller
            result_fh.close()
            os.remove(result_name)
        start = ret_str.find('tag')
        tag_str_len = 4;
        if (start > 0) and not (isinstance(tag, int)):
            if tag_bytes > 0:
                end = start + tag_str_len + int(tag_bytes * 2)
                tag[:] = str_to_hex(ret_str[start+tag_str_len:end])
            else:
                end = len(ret_str)
            p_key.kdf.tag.set_buf(str_to_hex(ret_str[start+tag_str_len:end]))
    os.remove(raw_name)
    return buff_sig
