#!/usr/bin/env python
#
# Copyright (c) 2013-2016 NVIDIA Corporation.  All Rights Reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#
# TNSPEC Tool
# (TNSPEC - "tidy and neat spec" OR "technically nerdy spec")
#
# NOTE: every feature implemented here must have a correponding test

from __future__ import print_function
from struct import pack, pack_into, unpack, unpack_from, calcsize as csz
import sys
import os
import getopt
import json
import collections
import copy
import mmap
import zlib
import binascii
import types
import re
import contextlib

__metaclass__ = type

###############################################################################
# Globals
###############################################################################

verbose = False
debug = False
g_spec_file = None
g_group = None
g_nctfile = None
g_stdin = False
g_outfile = None
g_argv_copy = ''

###############################################################################
# Helper Functions
###############################################################################

def pr(out, *args, **opt):
    """
    Core print function

    Parameters:
        out  - takes *NIX file descriptor number. 1 for stdout, 2 for stderr
        args - arguments passed as-is to print function (python 3 print
               function).
        opts - 'prefix' and 'end' kw args can be used to prefix and suffix the
               string/objects passed to 'args'
    """
    # 1 - stdout, 2 - stderr
    out -= 1
    std = [sys.stdout, sys.stderr]
    if 'prefix' in opt:
        print(opt['prefix'], end='', file=std[out])
    print(*args, file=std[out], end=opt.get('end','\n'))

def pr_err(*args):
    """
    Prints an error message to stderr
    """
    pr(2, *args, prefix=bcolors.FAIL, end=bcolors.ENDC + '\n')

def pr_warn(*args):
    """
    Prints a warning message to stderr
    """
    pr(2, *args, prefix=bcolors.WARNING, end=bcolors.ENDC + '\n')

def pr_ok_g(*args):
    """
    Prints a message to stdout [green]
    """
    pr(1, *args, prefix=bcolors.OKGREEN, end=bcolors.ENDC + '\n')

def pr_ok_b(*args):
    """
    Prints a message to stdout [blue]
    """
    pr(1, *args, prefix=bcolors.OKBLUE, end=bcolors.ENDC + '\n')

def pr_dbg(*args):
    """
    Prints a debug message. Only enabled when debug mode is enabled.
    """

    if not debug:
        return
    pr(1, *args, prefix=bcolors.HEADER+'DEBUG: '+bcolors.ENDC)

def D(s):
    """
    Converts a dictionary object into a JSON string.

    Parameters:
        s - Dictionary object

    Returns:
        JSON-formatted string
    """
    return json.dumps(s, sort_keys=True, indent=4, separators=(',',': '))

def command_failed():
    """
    Debugging function to print out the entire argument passed to this script.
    """
    if debug:
        # stderr is used by default
        pr_err("Command failed: 'tnspec %s'" % ' '.join(g_argv_copy))

def set_options(options):
    """
    Sets extra options (non command options)

    Parameters:
        options - getopt options
    """
    global g_spec_file, g_nctfile, g_outfile, g_group, debug, verbose

    try:
        opts, args = getopt.getopt(options, 'dvs:o:g:n:',
                ['verbose','spec=', 'nct=', 'group='])
    except:
        pr_err('invalid options. (check if option requires argument)')
        CmdHelp.usage(2)
        sys.exit(1)

    for o, a in opts:
        if o in ('-v', '--verbose'):
            verbose = True
        elif o in ('-s', '--spec'):
            g_spec_file = a
        elif o in ('-n', '--nct'):
            g_nctfile = a
        elif o in ('-g', '--group'):
            g_group = a
        elif o in ('-o'):
            g_outfile = a
        elif o == '-d':
            debug = True

@contextlib.contextmanager
def qopen(fobj, mode='rb'):
    """
    Universal file object generator - Handles file, stdout, stdin with the same
    interface. Must be used with "with"

    Parameters:
        fobj - (string) File name. Opens a file object which gets closed when
               done
               (sys.stdout/stdin) Returns it as-is, but does not attempt to
               close it
        mode - Passed to open() function. N/A when sys.stdout

    """
    if isinstance(fobj, types.StringTypes):
        f = open(fobj, mode)
    elif fobj in [sys.stdout, sys.stdin]:
        f = fobj
    else:
        f = None
    try:
        yield f
    finally:
        if isinstance(fobj, types.StringTypes):
            f.close()

###############################################################################
# Command Classes
###############################################################################

class Command(object):
    """
    Base Command Object. Every command must inherit this 'Command' object to
    implement 'help' (static method) and 'process' at least.

    Methods:
        init    - (optional) Initializes comamnd object. This gets called
                  before 'process' method is invoked.
        help    - Prints command-specific help messages. First argument passed
                  to this method determines the output stream (stdout, stderr)
        process - Command's entry point. Takes command arguments. Returns an
                  error message (string). Should return nothing if no error was
                  encountered.
    """
    @staticmethod
    def help(*args):
        pass
    def process(self, args):
        pr_err('Hah!')

class CmdNCT(Command):
    """
    NCT Command Class (derived from Command)

    Handles NCT command. See Command.help for sub-commands.
    """
    @staticmethod
    def help(*args):
        out = args[0]
        pr(out, "tnspec nct dump <[all]|tnspec|entry|nct> --nct <nctbin>")
        pr(out, "  dumps each or all fields or generates NCT in text format.")
        pr(out, "  if no option is passed, 'all' is assumed")
        if not verbose:
            pr(out, "  - 'tnspec help nct -v' to show all 'entry' names.")
        else:
            pr(out, "NCT Entries:")
            for e in NCT.base_entries:
                pr(out, "%2d| %20s" % (e['idx'], e['name']))
        pr(out, "")
        pr(out, "tnspec nct new <HW spec ID> -o <outfile> --spec <tnspec>")
        pr(out, "tnspec nct new -o <outfile>")
        pr(out, "  generates a new NCT binary")
        pr(out, "  Run 'tnspec list' for HW Spec ID list (aka board names)")
        pr(out, "")
        pr(out, "tnspec nct update -o <outfile> --nct <nctbin>")
        pr(out, "  updates the existing NCT binary from stdin or override env variable.")
        pr(out, "  TNSPEC_SET_HW/TNSPEC_SET_HW_JSON")
        pr(out, "")
        pr(out, "NOTE:")
        pr(out, "HW specs are required for creating a new NCT binary when 'new' is used.")
        pr(out, "HW specs are optional for updating a NCT binary when 'update' is used.")

    def __init__(self):
        pass

    @staticmethod
    def _dump(nct, key):
        """
        Converts NCT to formatted/pretty string representation.

        Parameters:
            nct - NCT object
            key - NCT field name to dump the data individually. If missing or
                  'all' is passed, the simple format of the entire data will be
                  returned.

        Returns:
            String representation of NCT data.
        """
        tmpl = '%2d|%12s| %s\n'
        out = ''
        if len(key) and key in ['all', 'tnspec'] + [e['name'] for e in NCT.base_entries]:
            if key == 'all':
                out += '  |      HEADER| %s\n' % str(map(lambda x:
                                                    x if isinstance(x,str)
                                                    else hex(x), nct.hdr['val']))
                out += '  |      TNSPEC| %s\n' % (
                        ('[%X] ' % nct.hdr['val'][8] +
                         '- use "tnspec nct dump tnspec" to view')
                         if nct.full_tnspec else '(null)')

                for e in nct.entries:
                    pr_dbg(e)
                    if e['val'] != None:
                        pr_dbg('key', e['name'] )
                        # Not always a string
                        rpr = NCT.print(e)
                        if isinstance(rpr, list) and len(rpr) > 4 and not verbose:
                            out += tmpl % (e['idx'], e['name'][:12], str(rpr[:3] + ['... more ...']))
                        else:
                            out += tmpl % (e['idx'], e['name'][:12], rpr)
            elif key == 'tnspec':
                if nct.full_tnspec:
                    out += json.dumps(nct.nctspec.get_specs(),
                            sort_keys=True, indent=4, separators=(',', ': '))
            else:
                # Dump values individually. Print headers (index, name) only when verbose is set.
                for e in NCT.base_entries:
                    if e['name'] == key:
                        break
                if e['val'] != None:
                    rpr = NCT.print(e)
                    if verbose:
                        out += tmpl % (e['idx'], e['name'][:8], rpr)
                    elif e['name'] == 'spec':
                        out += json.dumps(json.loads(rpr),
                                sort_keys=True, indent=4, separators=(',', ': '))
                    elif isinstance(rpr, list) or isinstance(rpr, tuple):
                        out += '\n'.join(rpr)
                    else:
                        out += str(NCT.print(e))
        return out

    def dump(self, args):
        """
        'dump' command handler
        """
        if not g_nctfile:
            return 'requires --nct <nct binary>'

        nct = NCT(g_nctfile)

        if len(args) == 0 or args[0] == 'all':
            pr(1, CmdNCT._dump(nct, 'all'), end='')
        elif len(args) and args[0] in ['tnspec']  + [e['name'] for e in NCT.base_entries]:
            pr(1, CmdNCT._dump(nct, args[0]))
        elif len(args) and args[0] == 'nct':
            nct.gen('-', 'txt')
        else:
            return "too many args or invalid entry name. " + \
                   "'tnspec help nct -v' to see a list of valid names"

    def new(self, args):
        """
        'new' command handler - Generates NCT binary.
        """
        reserved_keys = [ 'meta', 'hide' ]
        # FIXME: consider using Spec instead of HwSpec and taking simple spec only
        if not g_outfile:
            return 'you need to specify an output file.'
        if len(args) == 0 and not g_spec_file:
            _hwspec = HwSpec(filename='-').get_specs()
        elif len(args) == 1 and g_spec_file:
            spec_key = args[0]
            hwspec = HwSpec(group='hw', filename=g_spec_file)
            _hwspec = hwspec.get_specs(spec_key)
            if not _hwspec:
                pr_warn("%s doesn't seem to contain anything." % spec_key)
        else:
            return 'invalid command'

        if not _hwspec:
            return "nothing to generate."

        if g_nctfile == g_outfile:
            return "nctbin (%s) and output (%s) can't be the same." % (g_nctfile, g_outfile)

        # remove reserved keys
        for k in reserved_keys:
            if k in _hwspec.keys():
                pr_dbg("Removing reserved keys", k)
                del _hwspec[k]

        nct = NCT(_hwspec)
        if debug:
            nct.dump()

        nct.gen(g_outfile, 'bin')

    def update(self, args):
        """
        'update' command handler - updates NCT binary
        """

        if not (g_outfile and g_nctfile):
            return "you need to specify an output and nct file"

        if len(args) == 0:
            hwspec = HwSpec(filename='-', skip_process=True)
            # Do apply_override, but use merge_raw instead of merge which removes !'s
            hwspec.apply_override('', True)
            # By setting default to False, apply_default (we just did),
            # normalize, and remove_vals won't happen inside process()
            hwspec.process(default=False, process_filters=True)
            _hwspec = hwspec.get_specs()
        else:
            return "doesn't require any options for update"

        if len(_hwspec) == 0:
            pr_warn("Nothing to update - empty spec")
            return

        nct = NCT(g_nctfile)
        nct.update(_hwspec)

        nct.gen(g_outfile, 'bin')

    def process(self, args):
        """
        Main command handler.

        Supported commands:
            dump
            new
            update
        """
        if len(args) == 0:
            return 'missing arguments'

        cmd = args.pop(0)

        if cmd == 'dump':
            return self.dump(args)
        elif cmd == 'new':
            return self.new(args)
        elif cmd == 'update':
            return self.update(args)
        else:
            return 'Unknown command : ' + cmd

class CmdHelp(Command):
    """
    Help Command Class (derived from Command)
    """
    def __init__(self, cmd_table):
        self.cmds = cmd_table
        super(CmdHelp, self).__init__()

    @staticmethod
    def usage(out=1):
        """
        Prints the general usage.
        """
        pr(out, "tnspec <command> [options]")
        pr(out, "")
        pr(out, " commands:")
        pr(out, "   nct  reads, generates NCT in bin or text format")
        pr(out, "   spec lists entries or returns values mapped by key")
        pr(out, "")
        pr(out, " options:")
        pr(out, "   -s, --spec <tnspec>")
        pr(out, "   -g, --group <sw|hw>")
        pr(out, "   -n, --nct <nctbin>")
        pr(out, "   -v, --verbose")
        pr(out, "")
        pr(out, "See 'tnspec help <command>' for more information on a specific command.")

    @staticmethod
    def help(*args):
        """
        Takes a command and prints command-specific help message.
        """
        out = args[0]
        cmds = args[1]

        pr(out, "tnspec help <command>")
        pr(out, "  shows detailed usage for <command>")
        pr(out, "")
        if cmds:
            pr(out, "commands:")
            for e in sorted(cmds.keys()):
                pr(out, e)

    def process(self, args):
        if len(args):
            if args[0] not in self.cmds:
                return 'unsupported command'

            o = self.cmds[args[0]]['cls']
            if o:
                o.help(1, *tuple(self.cmds[args[0]].get('help',[])))
        else:
            CmdHelp.usage()

class CmdSpec(Command):
    """
    Spec Command Class
    """
    @staticmethod
    def help(*args):
        out = args[0]
        pr(out, "tnspec spec list [all|TNSPEC_ID] --spec <tnspec> [--group <sw|hw>]")
        pr(out, "  lists spec IDs. if --group is missing, it will list both hw and sw.")
        pr(out, "  'all' lists all non-reference-only entries including hidden ones.")
        pr(out, "  Use '-v' to include detailed descriptions.")
        pr(out, "")
        pr(out, "tnspec spec get [<query>] --spec <tnspec> [--group <sw|hw>]")
        pr(out, "tnspec spec get [<query>] [--group <sw|hw>]")
        pr(out, "  gets property information specified by <query>")
        pr(out, "")

    def init(self):
        self.specfile = g_spec_file
        self.group = g_group

        # top level error checking
        if self.group and self.group not in ['sw', 'hw']:
            return "--group must be set to either sw or hw"

    def list(self, args):
        """
        'list' command handler.

        Lists TNSPEC entries. If no group is specified, all entries are listed.

        Parameters:
            args - Optional argument to this command. See below.

        [args]
        'all'       - Prints all TNSPEC entries including hidden ones.
        <Empty>     - Prints TNSPEC entries.
        <TNSPEC ID> - Accepts full TNSPEC ID ('id' and 'config') or just 'id'.
                      Prints all matching entries.

        """
        list_all = False
        tns_id = ''
        tns_config = ''
        if not self.specfile:
            return 'requires specfile'

        # where hidden fields should be displayed.
        if len(args) > 0:
            list_all = True
            if args[0] != 'all':
                r = re.match('[\w\-_]+', args[0])
                tns_id = r.group(0) if r else ''
                r = re.match('[\w\-_]+\.([\w\-_]+)', args[0])
                tns_config = r.group(1) if r else ''

        # HW
        if self.group == 'hw' or self.group == None:
            _hwspec = HwSpec(group='hw', filename=self.specfile).get_specs()
            for e in sorted(_hwspec.keys()):
                if Spec.is_reference(e): continue
                if _hwspec[e].get('hide',False) and not list_all: continue
                if tns_id and _hwspec[e].get('id','') != tns_id: continue
                if tns_config and _hwspec[e].get('config','') != tns_config: continue
                if verbose:
                    d = '[HW][%s]' % _hwspec[e].get('desc', 'No Description')
                    pr(1, '%-38s %s' % (e, d))
                else:
                    pr(1, e)
        # SW
        if self.group == 'sw' or self.group == None:
            _swspec = SwSpec(group='sw', filename=self.specfile).get_specs()
            for e in sorted(_swspec.keys()):
                if Spec.is_reference(e): continue
                if _swspec[e].get('hide', False) and not list_all: continue
                if tns_id and e != tns_id: continue
                configs = sorted(_swspec[e].keys())

                for cfg in configs:
                    if cfg in [ 'compatible', 'desc', 'hide' ]: continue
                    if tns_config and tns_config != cfg: continue
                    if _swspec[e][cfg].get('hide', False) and not list_all: continue

                    if verbose:
                        d_base = _swspec[e].get('desc', e)
                        d_cfg = _swspec[e][cfg].get('desc',cfg)
                        d = d_base + ('|' if d_cfg else '') + \
                                     (d_cfg if d_cfg else '(No Description)')
                        d = '[SW][%s]' % d
                        pr(1, '%-38s %s' % (e + '.' + cfg, d))
                    else:
                        pr(1, '%-38s' % (e + '.' + cfg))

    def get(self, args):
        """
        'get' comamnd handler - queries TNSPEC using dot-notation and formats
        the string into a shell-programming friendly format.

        For example, the following can be used to query 'data1' field of TNSPEC
        ID (P3333-A00.default).

          self.get("P3333-A00.default.data1")

        Formmating of the final output:
        1. Array (list) => each value is printed per line.
        2. Boolean      => Lower-cased. e.g. True -> "true"

        Parameters:
            args - qeury. see Spec.get_specs for details.
        """
        q = None
        group_path = None
        fname = self.specfile if self.specfile else '-'
        group_path = ''

        if len(args) > 1:
            return 'too many queries'

        if self.specfile:
            group_path = self.group if self.group else ''

        spec = None

        query = args[0] if len(args) else ''

        if self.group == 'hw':
            spec = HwSpec(group=group_path, filename=fname)
        elif self.group == 'sw':
            spec = SwSpec(group=group_path, filename=fname)
        else:
            spec = Spec(group='', filename=fname, override_key='TNSPEC_SET_BASE')

        q = spec.get_specs(query)

        if isinstance(q, types.StringTypes):
            pr(1, q)
        elif isinstance(q, types.BooleanType):
            pr(1, repr(q).lower())
        elif isinstance(q, types.ListType):
            pr(1, '\n'.join(map(lambda x: str(x), q)))
        elif q == None or not len(q):
            pass
        else:
            pr(1, D(q))

    def process(self, args):
        """
        Command handler for 'spec' command
        """
        err = self.init()

        if err:
            return err
        if len(args) == 0:
            return 'missing arguments'

        cmd = args.pop(0)

        if cmd == 'list':
            return self.list(args)
        elif cmd == 'get':
            return self.get(args)
        elif cmd == 'test':
            SwSpec(group=self.group, filename=self.specfile)
            return ''
        else:
            return 'Unknown command : ' + cmd

###############################################################################
# NCT Class
###############################################################################
class NCT(object):
    """
    NCT Class

    This class represents NCT object containing data and methods needed to
    generate and update a NCT binary from TNSPEC data, or NCT binary to TNSPEC
    data
    """
    # TNSPEC Version
    tnspec_versions = {
        '1' : { 'magic' : 'TNS1' },
        '0' : { 'magic' : 'TNSo' }, # Old version
    }
    supported_tnspec = [ tnspec_versions['1']['magic'], tnspec_versions['0']['magic'] ]

    # global constants
    magic = 'nVCt'
    entry_offset = 0x4000
    tns_version = '1'
    tnsoffset = 0x100000
    nctbin_size = 2 * 1024 * 1024

    @staticmethod
    def print(e):
        """
        Returns a formatted string or a value depending on the target field's
        type.
        """
        if e['val'] != None:
            # handle special cases first
            if e['name'] == 'board_info':
                return 'Proc: ' + '.'.join(map(lambda x: str(x),e['val'][:3])) + \
                       ' PMU: ' + '.'.join(map(lambda x: str(x), e['val'][3:6])) + \
                       ' Disp: ' + '.'.join(map(lambda x: str(x), e['val'][-3:]))
            elif e['name'] == 'uuid':
                uuids = bytearray(csz(e['fmt']))
                # pack flat
                pack_into(e['fmt'], uuids, 0, *e['val'])
                # re-unpack
                uuids_fmt = '64s' * 16
                uuids = unpack_from(uuids_fmt, buffer(uuids))
                uuids = [ x.rstrip('\0') for x in uuids ]
                uuids = [ u for u in uuids if len(u) ]
                return uuids

            elif e['fmt'] == '6B':
                return ':'.join(map(lambda x: '%02X' % x,e['val']))
            elif e['fmt'].endswith('s'):
                return  str(e['val'][0]).rstrip('\0')
            elif e['fmt'].startswith(('I','H')):
                return e['val'][0]
            else:
                return map(lambda x: '0x%08x' % x, e['val'])

    @staticmethod
    def _nct_txt_tag(e):
        """
        (TO BE DEPRECATED)
        Returns a hex representation of data length. Only used to generate NCT
        text file format which is not in use anymore.
        """
        tag = {'s':0x80, 'B': 0x1a, 'H': 0x2a, 'I': 0x4a}
        if e['fmt'][0] in ['s', 'B', 'H', 'I']:
            t = tag[e['fmt'][0]] & 0xf0
        else:
            t = tag[e['fmt'][-1]]
        return hex(t)

    @staticmethod
    def _nct_txt_data(e):
        """
        (TO BE DEPRECATED)
        Returns the NCT text format for data. Only used to generate NCT text
        file format which is not in use anymore.
        """

        # string
        if e['fmt'].endswith('s'):
            return ' data:%s' % e['val'][0].rstrip('\0')
        elif e['fmt'] in [ 'B', 'H', 'I'] :
            return ' data:0x%x' % e['val'][0]
        else:
            return ';'.join([' data:0x%x' % x for x in e['val']])

    ############################################################################
    # TNSPEC -> NCT Converter
    #
    # Each _spec_* function is responsible for translating TNSPEC data into raw
    # values of NCT binary
    ############################################################################
    def _spec_str(e, s, name):
        """
        Takes a tnspec data as string and stores it as C-string.
        """
        if name in s:
            # use bytearray to make it mutable
            data = bytearray(csz(e['fmt']))
            data[:len(s[name])] = s[name].encode('ascii')
            data = str(data)
            e['val'] = unpack_from(e['fmt'], data)

    def _spec_null(e, s, unused):
        return

    def _spec_mac(e, s, name, save=False):
        """
        Converts MAC address format (xx:xx:xx:xx:xx:xx) into 6 unsigned bytes.
        """
        if name in s:
            mac = s[name].split(':')
            e['val'] = tuple(map(lambda x: int(x, 16), mac))

    def _spec_board(e, s, name):
        """
        Takes data from 'proc', 'pmu', 'disp' and stores them into 'board_info'
        field of NCT.
        """
        if set(('proc', 'pmu', 'disp')).intersection(set(s.keys())):
            e['val'] = (int(s.get('proc',{}).get('id', '0'),0),
                        int(s.get('proc',{}).get('sku','0'),0),
                        int(s.get('proc',{}).get('fab','0'),0),
                        int(s.get('pmu', {}).get('id', '0'),0),
                        int(s.get('pmu', {}).get('sku','0'),0),
                        int(s.get('pmu', {}).get('fab','0'),0),
                        int(s.get('disp',{}).get('id', '0'),0),
                        int(s.get('disp',{}).get('sku','0'),0),
                        int(s.get('disp',{}).get('fab','0'),0))

    def _spec_lcd(e, s, *unused):
        """
        Takes 'disp' (the same data used for 'board_info') and stores into
        'lcd' field of NCT.
        """
        if 'disp' in s:
            e['val'] = (int(s['disp'].get('id','0'),0),)

    def _spec_un(e, s, name):
        """
        Converts tnsped data into an integer.
        """
        if name in s:
            e['val'] = (int(s[name],0),)

    def _spec_arry(e, s, name):
        """
        Used when an array of values needs to be stored in NCT from an array in TNSPEC.
        """
        if name in s:
            num = int(e['fmt'][:-1])
            data = [0] * num
            # check if # of elements is greater than the expected.
            if len(s[name]) > num:
                pr_err("Number of elements (%d) in %s is greater than %d." %
                        (len(s[name]), name, num))
                sys.exit(1)
            data[:len(s[name])] = map(lambda x: int(x,0), s[name])
            e['val'] = tuple(data)

    def _spec_uuid(e, s, *unused_for_now):
        """
        Searches through all TNSPEC nodes with 'uuid' as a sub-node and packs
        all UUIDs into 'uuid' field of NCT.
        """
        uuid_fmt = '64s' # 64 bytes for each UUID
        uuid_max_entries = csz(e['fmt'])/csz(uuid_fmt)
        data = bytearray(csz(e['fmt']))
        use_tags = s.get('uuid',{}).get('use_tags', False)
        idx = 0
        for key, module in s.items():
            if isinstance(module, dict) and 'uuid' in module:
                if idx >= uuid_max_entries:
                    pr_err("Error: %s.uuid can't be added (only up to %d)" %
                            (module, uuid_max_entries))
                    sys.exit(1)
                if use_tags:
                    uuid = module.get('tag', key) + ':'
                else:
                    uuid = ''
                uuid += module['uuid']
                if len(uuid) > csz(uuid_fmt) - 1:
                    pr_err("Error: uuid '%s' is too long" % uuid)
                    sys.exit(1)
                data[idx*csz(uuid_fmt):len(uuid)] = uuid.encode('ascii')
                idx += 1
        if idx:
            data = buffer(data)
            e['val'] = unpack_from(e['fmt'], data)

    def _spec_tnspec_id(e, s, *unused):
        """
        Responsible for exporting TNSPEC ID from full TNSPEC.
        """
        export_keys = [ 'id', 'config', 'misc' ]
        spec = {}
        for ex in export_keys:
            if ex in s:
                spec[ex] = s[ex]
        spec_str = json.dumps(spec, separators=(',',':'))
        pr_dbg('spec_meta length:', len(spec_str))
        if len(spec_str) > csz(e['fmt']):
            pr_err('spec size too big! please file a bug..')
            sys.exit(1)

        data = bytearray(csz(e['fmt']))
        data[:len(spec_str)] = spec_str.encode('ascii')
        data = str(data)
        e['val'] = unpack_from(e['fmt'], data)

    # various formats
    _fmt_idx = _fmt_crc32 = 'I'
    _fmt_rsvd = '2I'
    _fmt_entry_hdr = _fmt_idx + _fmt_rsvd
    _fmt_entry_body = '256I'
    _fmt_entry_hdr_body = _fmt_entry_hdr + _fmt_entry_body
    _fmt_entry = _fmt_entry_hdr + _fmt_entry_body + _fmt_crc32

    # NCT structure
    # OFFSET |  4 bytes  |  4 bytes  |  4 bytes  |  4 bytes  |
    # --------------------------------------------------------
    # 0x0000 | 'nVCt'    | Vendor ID | Product ID| Version   |
    # 0x0010 | Revision  | 'TNS1'    | TNS offset| TNS length|
    # 0x0020 | TNS crc32 | Reserved  | Reserved  | Reserved  |
    # ...
    # Entries
    # 0x4000 | entry1 (1040B)
    # 0x4410 | entry2 (1040B)
    # 0x4820 | entry3 (1040B)
    # ...
    # TNSPEC
    # TNS length - # of words
    # 0x100000 | variable length (specified at offset 0x28)

    # default header
    header = \
        { 'fmt' : '4s4I4s3I',
          'val' : (magic,                                # 0 - magic
                   0xffff,                               # 1 - vendor id
                   0xffff,                               # 2 - product id
                   0x10000,                              # 3 - version
                   1,                                    # 4 - revision (auto-incremented)
                   tnspec_versions[tns_version]['magic'],# 5 - TNSPEC magic
                   tnsoffset,                            # 6 - TNSPEC offset
                   0,                                    # 7 - TNSPEC length in bytes
                   0xa5a5a5a5)}                          # 8 - TNSPEC crc32

    # base entries - always make a copy when instantiated.
    # If 'None' is used to spec functions, 'name' will be passed.
    base_entries = \
    [
        {'name': 'serial'       , 'idx' : 0 , 'fmt': '30s'  , 'fn': _spec_str, 'args': 'sn'},
        {'name': 'wifi'         , 'idx' : 1 , 'fmt': '6B'   , 'fn': _spec_mac  },
        {'name': 'bt'           , 'idx' : 2 , 'fmt': '6B'   , 'fn': _spec_mac  },
        {'name': 'cm'           , 'idx' : 3 , 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'lbh'          , 'idx' : 4 , 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'factory_mode' , 'idx' : 5 , 'fmt': 'I'    , 'fn': _spec_un   },
        {'name': 'ramdump'      , 'idx' : 6 , 'fmt': 'I'    , 'fn': _spec_un   },
        {'name': 'board_info'   , 'idx' : 8 , 'fmt': '9I'   , 'fn': _spec_board},
        {'name': 'gps'          , 'idx' : 9 , 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'lcd'          , 'idx' : 10, 'fmt': 'H'    , 'fn': _spec_lcd  },
        {'name': 'accelerometer', 'idx' : 11, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'compass'      , 'idx' : 12, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'gyroscope'    , 'idx' : 13, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'light'        , 'idx' : 14, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'charger'      , 'idx' : 15, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'touch'        , 'idx' : 16, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'fuelgauge'    , 'idx' : 17, 'fmt': 'H'    , 'fn': _spec_un   },
        {'name': 'wcc'          , 'idx' : 18, 'fmt': 'I'    , 'fn': _spec_un   },
        {'name': 'unsued'       , 'idx' : 19, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 20, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 21, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 22, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 23, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 24, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 25, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 26, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 27, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 28, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 29, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 30, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 31, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 32, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 33, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 34, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 35, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 36, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'unsued'       , 'idx' : 37, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'batt_model'   , 'idx' : 38, 'fmt': '256I' , 'fn': _spec_null },
        {'name': 'dbgport'      , 'idx' : 39, 'fmt': 'I'    , 'fn': _spec_un   },
        {'name': 'batt_make'    , 'idx' : 40, 'fmt': '20s'  , 'fn': _spec_str  },
        {'name': 'batt_count'   , 'idx' : 41, 'fmt': 'I'    , 'fn': _spec_un   },
        {'name': 'spec'         , 'idx' : 42, 'fmt': '1024s', 'fn': _spec_tnspec_id},
        {'name': 'uuid'         , 'idx' : 43, 'fmt': '256I' , 'fn': _spec_uuid }
    ]

    def __init__(self, source):
        """
        NCT Object Constructor

        Constructs NCT object using two possible sources, either from NCT
        binary (when 'source' is a string representing the path of the NCT
        binary to read from) or a dictional object.

        Parameters:
            source - can be either "string" or "dictionary"
        """
        # do a shallow copy on initial table.
        self.rawbin = None
        self.full_tnspec = False
        self.hdr = copy.copy(NCT.header)
        self.entries = copy.copy(NCT.base_entries)
        self.nctspec = Spec()

        # nullify all 'val's
        for e in self.entries:
            e['val'] = None

        if isinstance(source, str):
            self._init_nctbin(source)
        elif isinstance(source, dict):
            self.nctspec.set_specs(source)
            self.full_tnspec = True
        else:
            pr_err("NCT: unrecognized nct source - ", source)
            sys.exit(1)
        self.initialize_from_spec()

    def _init_nctbin(self, nctbin):
        """
        Inializes NCT object from NCT binary.
        """
        if not os.path.exists(nctbin):
            command_failed()
            pr_err("Error: nct file '%s' doesn't exist." % nctbin)
            CmdHelp.usage(2)
            sys.exit(1)

        with qopen(nctbin, 'rb') as f:
            self.rawbin = f.read()

            if (len(self.rawbin) != NCT.nctbin_size or
                self.rawbin[:4] != NCT.magic):
                pr_err("'%s' doesn't seem to be a valid NCT binary" % nctbin)
                sys.exit(1)

        # read in the header
        self.hdr['val'] = unpack_from(self.hdr['fmt'], self.rawbin)
        pr_dbg(map(lambda x: x if isinstance(x,str) else hex(x), self.hdr['val']))

        self._load_tnspec_from_nct()

        # If full tnspec is loaded, nullify the existing binary since we're
        # going to generate a new one based on the full tnspec. Otherwise, we
        # keep all other existing NCT entries
        if self.full_tnspec:
            self.rawbin = None
            return

        # Only if full TNSPEC was not found.
        for e in self.entries:
            base = NCT.entry_offset + e['idx'] * csz(NCT._fmt_entry)
            e['raw'] = self.rawbin[base : base + csz(NCT._fmt_entry)]
            # some sanity checks

            # idx
            idx = unpack('I',e['raw'][:csz(NCT._fmt_idx)])[0]
            if e['idx'] != idx:
                pr_dbg('Invalid idx. Expected %d, but got %d' % (e['idx'], idx))
                continue

            # crc32
            nct_crc32 = unpack('I',e['raw'][-csz(NCT._fmt_crc32):])[0]
            calc_crc32 = zlib.crc32(e['raw'][:-csz(NCT._fmt_crc32)]) & 0xffffffff
            if calc_crc32 != nct_crc32 :
                pr_dbg('CRC32 error. Expected %x, but got %x' %
                    (calc_crc32, nct_crc32))
                continue

            # save values
            e['val'] = unpack_from(e['fmt'], e['raw'][csz(NCT._fmt_entry_hdr):])

    def _load_tnspec_from_nct(self):
        """
        Called by _init_nctbin to load the entire TNSPEC from NCT. Actual NCT
        object initialization happens in initialize_from_spec.
        """

        # initializes TNSPEC.
        # check if the loaded NCT.bin supports TNS1.

        if self.hdr['val'][5] in NCT.supported_tnspec:
            tns_offset = self.hdr['val'][6]
            tns_length = self.hdr['val'][7]
            tns_raw = self.rawbin[tns_offset:tns_offset + tns_length]
            tns_crc32 = self.hdr['val'][8]
            tns_crc32_calc = zlib.crc32(tns_raw) & 0xffffffff
            if tns_crc32 == tns_crc32_calc:
                self.full_tnspec = True
                self.nctspec.set_specs(json.loads(tns_raw))
            else:
                pr_err("Full TNSPEC found, but crc check failed.")

        # Fall-back mode.
        if not self.full_tnspec:
            pr_warn("Warning: Full TNSPEC not found.")

            # Simple spec stores 'id' and 'config' only
            for e in self.entries:
                if e['name'] != 'spec':
                    continue
                base = NCT.entry_offset + e['idx'] * csz(NCT._fmt_entry)
                e['raw'] = self.rawbin[base : base + csz(NCT._fmt_entry)]

                # idx
                idx = unpack('I',e['raw'][:csz(NCT._fmt_idx)])[0]
                if e['idx'] != idx:
                    pr_dbg('Invalid idx. Expected %d, but got %d' % (e['idx'], idx))
                    break

                # crc32
                nct_crc32 = unpack('I',e['raw'][-csz(NCT._fmt_crc32):])[0]
                calc_crc32 = zlib.crc32(e['raw'][:-csz(NCT._fmt_crc32)]) & 0xffffffff
                if calc_crc32 != nct_crc32 :
                    pr_dbg('CRC32 error. Expected %x, but got %x' %
                        (calc_crc32, nct_crc32))
                    break

                # save values
                e['val'] = unpack_from(e['fmt'], e['raw'][csz(NCT._fmt_entry_hdr):])

                _simple = json.loads(NCT.print(e))
                self.nctspec.merge_specs(_simple)

                break

    def _save_tnspec_to_nct(self):
        """
        Called by _nct_bin (NCT binary generator) to generate NCT binary from
        TNSPEC loaded to this NCT object.
        """
        if self.full_tnspec:
            # convert tnspec to str
            tnspec_str = json.dumps(self.nctspec.get_specs(), sort_keys=True, separators=(',',':'))
            tnspec_length = len(tnspec_str)
            pr_dbg("TNSPEC length: ", tnspec_length)

            if tnspec_length > NCT.nctbin_size - NCT.tnsoffset:
                pr_err("TNSPEC is too large.")
                sys.exit(1)

            # Zero out TNSPEC space
            self.rawbin[NCT.tnsoffset:NCT.nctbin_size] = '\x00' * (NCT.nctbin_size - NCT.tnsoffset)
            # Write TNSPEC str
            self.rawbin[NCT.tnsoffset:NCT.tnsoffset + tnspec_length] = tnspec_str

            # Update header information
            hdr = list(self.hdr['val'])
            # Set tnspec length to header
            hdr[7] = tnspec_length
            # Update crc32
            hdr[8] = zlib.crc32(tnspec_str) & 0xffffffff
            # Convert it back to tuple type
            self.hdr['val'] = tuple(hdr)
            pr_dbg("TNSPEC dump")
            pr_dbg(tnspec_str)

    def initialize_from_spec(self):
        """
        Populates NCT structure from TNSPEC loaded to this object.
        """
        for e in self.entries:
            # If the target entry is specified in no_export, we don't load values to NCT
            if e['name'] in self._get_exclude():
                continue
            e['fn'](e, self.nctspec.get_specs(), e.get('args', e['name']))
            # if e['val'] has some valid value, update revision
            if e['val'] and e['idx'] + 1 > self.hdr['val'][4]:
                hdr = list(self.hdr['val'])
                hdr[4] = e['idx'] + 1
                self.hdr['val'] = tuple(hdr)

    def _get_exclude(self):
        no_export = self.nctspec.get_specs('__nct__.exclude')
        if isinstance(no_export, types.ListType):
            return no_export
        else:
            return []
    def _get_tnspec_version(self):
        tns_ver = self.nctspec.get_specs('__nct__.v')
        if tns_ver:
            if tns_ver in NCT.tnspec_versions:
                return tns_ver
            else:
                pr_warn('Unknown TNSPEC Version - (%s). Ignored.' % tns_ver)
        return NCT.tns_version

    def update(self, spec):
        """
        Updates NCT structure using the TNSPEC passed.

        Parameters:
            spec - TNSPEC containing fields to update.
        """
        if not self.full_tnspec:
            pr_warn("Warning: Full TNSPEC wasn't found. Update functionality is limited.")

        self.nctspec.merge_specs(spec)
        self.nctspec.process()
        self.initialize_from_spec()

    def gen(self, outfile, mode):
        """
        Generates NCT file (binary or text). Note that the text format is to be deprecated.

        Parameters:
            outfile - the name of the output NCT file
            mode    - 'bin' or 'txt'
        """
        if mode not in ['bin', 'txt']:
            pr_err('Error: invalid NCT output format %s', mode)
            sys.exit(1)

        if mode == 'txt':
            self._gen_txt(outfile)
        elif mode == 'bin':
            self._gen_bin(outfile)

    def _gen_txt(self, outfile):
        """
        (TO BE DEPRECATED)
        Generates NCT text.

        Parameters:
            outfile - the name of the output file.
        """
        # template
        nct_tmpl_header = \
'''// Automatically generated by 'tnspec nct dump nct'
//
// [NCT TABLE - %s (ver. %d.%d)]
//
// WARNING: NCT (TEXT VERSION) DOESN'T SUPPORT FULL TNSPEC FORMAT
// It is required to upload NCT BIN separately to use FULL TNSPEC.
//
%s//
<version:0x%08x>
<vid:0x%x; pid:0x%x>
<revision:%d>
<offset:0x%x>
'''
        nct_tmpl_entry = "<name: %12s; idx:%2d; tag:%s;%s>\n"

        tbl = ''
        idstr = 'unknown.default'
        # pretty table
        for e in CmdNCT._dump(self, 'all').split('\n'):
            tbl += '// ' + e + '\n'

        # id.config
        for e in self.entries:
            if e['name'] == 'spec' and e['val']:
                sm = self.print(e)
                j = json.loads(sm)
                idstr = j.get('id','unknown') + '.' + j.get('config', 'default')
        # header
        out = nct_tmpl_header % (
                idstr,
                # version (e.g. 1.0)
                self.hdr['val'][3] >> 16,
                self.hdr['val'][3] & 0xffff,
                # pretty
                tbl,
                # version
                self.hdr['val'][3],
                # vid, pid
                self.hdr['val'][1], self.hdr['val'][2],
                # revision
                self.hdr['val'][4],
                # offset
                NCT.entry_offset)
        # entries
        for e in self.entries:
            if e['val'] != None:
                out += nct_tmpl_entry % (
                        e['name'], e['idx'], NCT._nct_txt_tag(e), NCT._nct_txt_data(e))
        pr_dbg(out)
        with qopen(outfile if outfile != '-' else sys.stdout, 'w') as f:
            f.write(out)

    def _gen_bin(self, outfile):
        """
        Generates NCT binary

        Parameters:
            outfile - the name of the output file.
        """
        pr_dbg("using the pre-loaded NCT binary" if self.rawbin else
                "creating new NCT")
        rawbin =  bytearray(self.rawbin) if self.rawbin else bytearray(NCT.nctbin_size)
        self.rawbin = rawbin

        self._save_tnspec_to_nct()

        # Update TNSPEC Magic
        hdr = list(self.hdr['val'])
        hdr[5] = NCT.tnspec_versions[self._get_tnspec_version()]['magic']
        self.hdr['val'] = tuple(hdr)

        pack_into(self.hdr['fmt'], rawbin, 0, *self.hdr['val'])

        for e in self.entries:
            # It is intentional we don't touch the fields that aren't specified
            # by spec for backward compatibility. If full tnspec is not used,
            # we only touch the fields that are set in the currnet spec.
            if e['val'] != None:
                offset = NCT.entry_offset + e['idx'] * csz(NCT._fmt_entry)
                entry_bin = bytearray(csz(NCT._fmt_entry))
                # idx
                pack_into(NCT._fmt_idx, entry_bin, 0, e['idx'])
                # body
                pack_into(e['fmt'], entry_bin, csz(NCT._fmt_entry_hdr), *e['val'])
                # crc32
                pack_into(NCT._fmt_crc32, entry_bin,
                        csz(NCT._fmt_entry_hdr_body),
                        zlib.crc32(bytes(entry_bin[:-csz(NCT._fmt_crc32)])) & 0xffffffff)
                # store
                assert len(rawbin[offset:offset+csz(NCT._fmt_entry)]) == len(entry_bin)
                rawbin[offset:offset+csz(NCT._fmt_entry)] = entry_bin

            # Explicitly invalidate NCT entries if specified
            if e['name'] in self._get_exclude() :
                offset = NCT.entry_offset + e['idx'] * csz(NCT._fmt_entry)
                entry_bin = bytearray(csz(NCT._fmt_entry))
                assert len(rawbin[offset:offset+csz(NCT._fmt_entry)]) == len(entry_bin)
                rawbin[offset:offset+csz(NCT._fmt_entry)] = entry_bin

        with qopen(outfile, 'wb') as f:
            f.write(rawbin)

    # debug only
    def dump(self):
        pr(1, '  |      HEADER|', map(lambda x: x if isinstance(x,str) else hex(x), self.hdr['val']))
        for e in self.entries:
            if e['val'] != None:
                pr(1, '%2d|%12s|' % (e['idx'], e['name'][:12]), NCT.print(e))

###############################################################################
# Spec Classes
###############################################################################

# Base Spec Class
class Spec(object):
    """
    Spec Class

    Represents TNSPEC. This base class implements core methods for processing
    TNSPEC common to derived classes.

    Some of the most important methods this class supports:
        - Merging (inheritance)
        - Override
        - Special Operator
    """
    supported_versions = ['2.0', '2.1']

    def __init__(self, **args):
        """
        Constructor responsible for loading data, setting up key properties
        (env variable name to override)

        Parameters - args[*]:
            'group'        - Group name. Used for full spec only.
            'filename'     - If set, the corresponding file will be used to
                             read TNSPEC.
            'override_key' - The name of env variable to read the override data
                             from.
            'skip_process' - Boolean value to skip processing of the spec.
                             'Processing' is responsible for normalizing keys
                             (removing locall keys, overriding, executing
                             filters, removing keys.)
        """

        # Full TNSPEC always passes non-zero length group path (e.g. 'sw', 'hw', ..)
        # If group path is empty, it's assumed to be a single spec (no bases, etc..)

        self.group = args.get('group', '')
        self.full_spec = True if self.group else False
        self.filename = args.get('filename', None)
        self.local_keys = []
        self.filters = []
        self.specs = self.src = {}
        self.dirname = ''
        self.override_env = args.get('override_key', '')

        if self.filename != None and self.filename != '-':
            if not os.path.exists(self.filename):
                command_failed()
                pr_err("Error: tnspec file '%s' doesn't exist." % self.filename )
                CmdHelp.usage(2)
                sys.exit(1)
            self.dirname = os.path.dirname(self.filename)

        if self.filename:
            with qopen(self.filename if self.filename != '-'  else sys.stdin) as f:
                try:
                    data = f.read()
                    if not data or data == '\n':
                        data = '{}'
                    self.src = json.loads(data)
                except ValueError as detail:
                    pr_err("Error in %s: " % self.filename if self.filename else 'stdin', detail)
                    sys.exit(1)
                except KeyboardInterrupt:
                    sys.exit(0)

            # check version, remove comments
            self.preprocess()

        if self.full_spec:
            if self.group in self.src:
                for s in self.src[self.group].keys():
                    pr_dbg('processing ', s)
                    self._flatten(self.group, s)
                self.specs = self.src[self.group]
        else:
            self.specs = self.src

        skip_process = args.get('skip_process', False)
        if not skip_process:
            self.process()

    def _flatten(self, root_key, spec_name):
        """
        Resolves "base" and "bases" keys

        Parameters:
            root_key  - The top level key containing nodes which need to be
                        visited and flattened.
            spec_name - The key that's currenly being resolved. e.g. Key
                        specified in "base" or "bases"
        """
        root = self.src[root_key]
        spec = root[spec_name]
        bases = [spec.get('base')] + spec.get('bases',[])

        # DO NOT remove dupes - ordering is important
        # bases = list(set(bases))

        if None in bases:
            bases.remove(None)

        # remove these keys.
        if 'bases' in spec: del spec['bases']
        if 'base' in spec: del spec['base']

        if len(bases) == 0:
            pr_dbg('Resolved ' + spec_name)
            return spec

        copied_spec = {}
        for base_spec_name in bases:
            pr_dbg('Resolving ' + base_spec_name)
            if base_spec_name not in root:
                pr_err("Error: base '%s' in '%s' not found." % (base_spec_name, spec_name))
                sys.exit(1)
            c = copy.deepcopy(self._flatten(root_key, base_spec_name))

            Spec.merge(copied_spec, c, self.local_keys)

        # merge all of resolved bases
        Spec.merge(copied_spec, spec, self.local_keys)
        root[spec_name] = copied_spec
        return root[spec_name]

    @staticmethod
    def _append_path(current, key):
        """
        Helper function to help building the full path while visiting each node.

        Parameters:
            current - Current path (starts with '')
            key     - A new node being visited

        Returns:
            The name of the path (in dot notation) being currently visited.
        """
        if current != '':
            current += '.'
        current += key if key[0] not in ['.', '!'] else key[1:]
        return current

    # Operators
    op_push = '[+]'
    ops = [ op_push ]
    @staticmethod
    def _handle_ops(base, new, key):
        """
        Main Operators Handler

        Supports the following operator:
            [+] - Pushes array elements into the existing array of the same name.

        Parameters:
            base - The target dictionary to merge to
            new  - The new dictionary object to merge into 'base'
            key  - The name of the key with supported operators.
        """
        found = False

        for op in Spec.ops:
            if key.endswith(op):
                base_key = key[:-len(op)]
                if base_key.startswith('.'): base_key = base_key[1:]
                found = True
                break
        assert found

        v1 = []
        v2 = new[key]

        if op == Spec.op_push:
            if not isinstance(v2, list):
                pr_err("'%s' expects an array:" % key, v2)
                sys.exit(1)
            if key == op:
                pr_err(op + " can't be used alone.")
                sys.exit(1)

            # Always check key[+] first. If base already contains [+], it means
            # the base already has an open array (where elements can be pushed)
            # and this node should be used to continue pushing elements. Keep
            # in mind that base can contain up to 2 types of opens arrays of
            # the same name.
            #
            # For example,
            # 1. array[+] : [e1, e2, e3, e4] (e4 was added previously or just now)
            # 2. .array[+] : [e1, e2, e3, e4] (e4 is being added, but it won't
            #    be used to as a source array to push new elements because it
            #    won't be available for merging - removed by merge())
            if base.get(base_key + Spec.op_push):
                v1 = base.get(base_key + Spec.op_push)
                if not isinstance(v1, list):
                    pr_err(base_key + Spec.op_push + " is not an array.")
                    sys.exit(1)
            elif base.get(base_key):
                # convert the regular array to an open array
                v1 = base.get(base_key)
                if not isinstance(v1, list):
                    pr_dbg("'%s' - base key '%s' doesn't have an array (will ignore):"
                            % (key, base_key), v1)
                    v1 = []
                assert not base.get(base_key + Spec.op_push)
                del base[base_key]

                # NOTE: base[base_key[+]] will be overwritten by base[key] = v1
                # + v2 below except when 'key' contains the '.' prefix (Case
                # 2). In that case, base[base_key[+]] stores the only keys that
                # weren't local.
                base[base_key + Spec.op_push] = v1

            if v1:
                base[key] = v1 + v2
            else:
                base[key] = v2

    @staticmethod
    def merge_raw(base, new):
        """
        Merges two dict objects
        """
        for k,v2 in new.items():
            v1 = base.get(k) # returns None if v1 has no value for this key

            if (isinstance(v1, collections.Mapping) and
                isinstance(v2, collections.Mapping)):
                Spec.merge_raw(v1, v2)
            elif k.endswith(tuple(Spec.ops)):
                Spec._handle_ops(base, new, k)
            else:
                # if there's an open array with the same name, delete it.
                if base.get(k + Spec.op_push):
                    del base[k + Spec.op_push]
                base[k] = v2

    @staticmethod
    def merge(base, new, local_keys=[]):
        """
        Merges two dict objects with normalization of the keys.
        """
        # remove local keys
        Spec._remove_keys(base, '.', local_keys)
        pr_dbg("base", D(base))
        pr_dbg("new", D(new))
        Spec.merge_raw(base, new)
        pr_dbg("merged", D(base))
        # normalize keys with '!' (remove '!')
        # normalizing also overwrites a node from base with the same key without !
        Spec._normalize(base, ['!'])

    @staticmethod
    def _remove_keys(d, prefix, keys_remove=[], path=''):
        """
        Removes keys with 'prefix' or keys in 'keys_remove'
        """
        if not isinstance(d, collections.Mapping): return
        keys = d.keys()
        for k in keys:
            _path = Spec._append_path(path, k)
            if k.startswith(prefix) or _path in keys_remove:
                del d[k]
            elif isinstance(d[k], collections.Mapping):
                Spec._remove_keys(d[k], prefix, keys_remove, _path)

    @staticmethod
    def _remove_vals(d, s, path=''):
        """
        Removes keys whose value matches 's'
        """
        if not isinstance(d, collections.Mapping): return
        keys = d.keys()
        for k in keys:
            _path = Spec._append_path(path, k)
            if Spec.is_reference(_path): continue
            if d[k] == s:
                del d[k]
            elif isinstance(d[k], collections.Mapping):
                Spec._remove_vals(d[k], s, _path)

    @staticmethod
    def _import(s, dirname=''):
        """
        Expand current spec if value contains supported import magic keys.

        @file://<file>:<key_path> - Replace this key with the contents of <file>
        """
        if not isinstance(s, collections.Mapping): return
        for k,v in s.items():
            if isinstance(v, types.StringTypes):
                r = re.match('@file://([\w+-\.]+)', v)
                if r:
                    ext_spec = r.group(1)
                    r = re.match('@file://[\w+-\.]+:(.+)', v)
                    ext_keys = r.group(1) if r else ''
                    # do a "raw-import"
                    s[k] = Spec(filename=os.path.join(dirname, ext_spec), skip_process=True).get_specs(ext_keys)
            elif isinstance(v, collections.Mapping):
                Spec._import(s[k], dirname)

    @staticmethod
    def _normalize(d, prefixes=[], suffixes=[], path=''):
        """
        Removes the specified prefixes/suffixes.
        """
        def normalized(key):
            if (any(key.startswith(x) for x in prefixes) or
                any(key.endswith(x)   for x in suffixes)): return False
            return True
        def normalize(key):
            for p in prefixes:
                if key.startswith(p):
                    key = key[len(p):]
                    break
            for s in suffixes:
                if key.endswith(s):
                    key = key[:-len(s)]
            return key

        if not isinstance(d, collections.Mapping): return
        keys = d.keys()
        for key in keys:
            _path = Spec._append_path(path, key)
            if Spec.is_reference(_path): continue
            if not normalized(key):
                k = normalize(key)
                if not k:
                    pr_dbg("normalize: deleting prefix/suffix only keys: " + key)
                    del d[key]
                    continue
                assert k != key
                d[k] = d[key]
                del d[key]
                key = k
            if isinstance(d[key], collections.Mapping):
                Spec._normalize(d[key], prefixes, suffixes, _path)

    @staticmethod
    def is_reference(key):
        """
        Check whether the key is a reference-only key.

        Returns:
            True  - When 'key' is a reference
            False - Otherwise
        """
        return key and key[0] == '&'

    def process_filters(self):
        """
        Processes registered filters

        This is used typically when additional processing needs to be done.
        """
        for h in self.filters:
            pr_dbg('Processing filter', h)
            key = h['key']

            if self.full_spec:
                for k,spec in self.specs.items():
                    if Spec.is_reference(k): continue
                    if key in spec:
                        spec[key] = h['fn'](spec[key])
            else:
                if key in self.specs:
                        self.specs[key] = h['fn'](self.specs[key])

    def register_filter(self, filter):
        """
        Registers filters based on keys.

        Parameters:
            filter - Object containing 'key' and 'fn' which is invoked when
                     'key' is found in the spec.
        """
        assert set(filter.keys()) == set(['key', 'fn'])
        pr_dbg('Registering filter', filter)
        self.filters.append(filter)

    def _check_version(self):
        """
        Check TNSPEC version and prints an appropriate warning message if it's
        dated.
        """
        if self.full_spec:
            if self.group in self.src:
                # version is top-level key, but only existent in full spec
                self.version = self.src.get('version', '')
                if len(self.version) == 0:
                    pr_warn("version is missing!")
                elif self.version not in Spec.supported_versions:
                    pr_err("Version %s is not supported." % self.version)
                    pr_warn("Trying anyway....")
            else:
                pr_err("Spec group '%s' is not found in spec." % self.group)
                sys.exit(1)

    def preprocess(self):
        """
        Preprocesses TNSPEC. Comments are removed here.
        """
        self._check_version()

        Spec._remove_keys(self.src, '#')
        Spec._import(self.src, self.dirname)

        if self.full_spec:
            if self.group in self.src:
                if '.' in self.src[self.group]:
                    self.local_keys = self.src[self.group]['.']
                    del self.src[self.group]['.']
            else:
                pr_err("Spec group '%s' is not found in spec." % self.group)
                sys.exit(1)
        else:
            # check if reference key is found in non-full spec.
            for k in self.src:
                if Spec.is_reference(k):
                    pr_warn("Reference key '%s' is found in a single spec format" % k)

    # spec.process
    def process(self,**options):
        """
        Main 'process' method. Responsible for normalizing keys (removes
        reserved prefixes or suffixes), applying override keys, processing
        registered filters, and removing keys whose value matches exactly '-'.

        Parameters - options[*] :
           'normalize'       - Boolean. Normalization takes when set to True.
           'apply_override'  - Boolean. Applies overrides when set to True.
           'process_filters' - Boolean. Processes filters when set to True.
           'remove_vals'     - Boolean. Removes keys whose values match '-'
                               when set to True.
        """
        default=options.get('default',True)
        pr_dbg('process options: ', options)
        if options.get('apply_override', default):
            self.apply_override()
        if options.get('import', default):
            # 2nd pass import to handle import keys from override keys
            Spec._import(self.specs, self.dirname)
        if options.get('normalize', default):
            Spec._normalize(self.specs, [], ['[+]'])
            Spec._normalize(self.specs, ['.', '!'])
        if options.get('process_filters', default):
            self.process_filters()
        if options.get('remove_vals', default):
            Spec._remove_vals(self.specs, '-')

    def set_specs(self, specs):
        """
        Sets this object's main spec to 'specs' passed.
        """
        self.specs = specs

    def get_specs(self, query=''):
        """
        Queries TNSPEC using the query string passed in 'query'.

        Parameters:
            query - Query string in dot notation. If this ends with '.', it
            returns a list of underlying keys instead of keys and values which
            is the default behavior.

        Returns:
            Values queried by 'query'. Returns the whole data if empty.
        """
        keys_only = False
        if query.endswith('.'):
            keys_only = True
            query = query[:-1]

        s = self.specs
        if query:
            cur_path = '<ROOT>'
            for k in query.split('.'):
                if not isinstance(s, collections.Mapping) :
                    pr_err("'%s' must be 'Object Type' to satisfy the query '%s'" %
                            (cur_path, query))
                    pr_err("'%s' gives:" % cur_path)
                    pr_warn(s)
                    sys.exit(1)
                cur_path = cur_path + '.' + k if cur_path != '<ROOT>' else k
                s = s.get(k,{})

        if keys_only:
            return s.keys() if isinstance(s, collections.Mapping) else []
        else:
            # return as-is
            return s

    # merge with new specs
    def merge_specs(self, specs):
        """
        Merges specs specified in 'specs' to this object's main specs.

        Parameters:
            specs - Dict object to merge.
        """
        Spec.merge(self.specs, specs)

    @staticmethod
    def set_val(base, path, val):
        """
        Sets (key,value) to 'base'

        Note that values in 'val' must be of String and no other types are supported.

        Parameters:
            base  - Target dict object to values ('val) under 'path' (dot notation).
            path  - Specifies the key to set values to.
            val   - Values to set. Array elements can be used. See below.

        Passing array elements to 'val':
            Typical usage of 'set_val' looks like the following:
                * set_val(obj, 'main_key.sub_key', 'value')
            And this sets 'value' to 'main_key.sub_key'.
                main_key.subkey : value

            If 'sub_key' is expecting a list of elements, the following can be
            used to set an array of strings.
                * set_val(obj, 'main_key.sub_key', 'value1,value2,value3')
            That is,
                main_key.subkey : [ value1, value2, value3 ]

            If it's needed to assign a single element array, ',' can be suffixed.
                * set_val(obj, 'main_key.sub_key', 'value1,')
            That is,
                main_key.subkey : [ value1 ]
        """
        # path must not be null
        assert path
        # consider supporting non-string types: dict, val, etc..
        assert isinstance(val, types.StringTypes)

        path = path.split('.')
        for k in path[:-1]:
            pr_dbg(type(base), k)
            if (k not in base) or (not isinstance(base[k], collections.Mapping)):
                base[k] = {}
            base = base.get(k) # base[k]

        pr_dbg(base, path, path[-1], val)
        val = val.split(',')

        if len(val) == 1:
            # scalar value (no ,)
            val = val[0]
        elif len(val) > 1 and not val[-1]:
            # Handle single element array
            val = val[:-1]

        base[path[-1]] = val

    def apply_override(self, prefix='', merge_raw=False):
        """
        Overrides (key, value) from override env variable.

        Supports two types of sources.

            1. String : a simple way to override data. Suitable for overriding
                        string values or array elements.
            2. JSON   : Any data that can't be represented in String can be
                        passed as-is in JSON format. The environment variable
                        used here is the default override env variable +
                        '_JSON'.

                        e.g. TNSPEC_SET_BASE for String, TNSPEC_SET_BASE_JSON
                        for JSON
        """
        if self.override_env in os.environ:
            _override_env_str = os.environ.get(self.override_env, '')
            if _override_env_str:
                kv = _override_env_str.split(';')
                override = [tuple(e.strip().split('=')) for e in kv]
                pr_dbg('override being applied (simple)', prefix, override)

                if override:
                    override_spec = {}
                    for _kv in override:
                        if len(_kv) != 2:
                            pr_err("\"%s=%s\" is not a valid override string." %
                                    (self.override_env,_override_env_str))
                            sys.exit(1)
                        Spec.set_val(override_spec, _kv[0], _kv[1])

                    # Normalizes local keys before applying overrides
                    Spec._normalize(self.get_specs(prefix), ['.'])

                    pr_dbg('base spec -> :', D(self.get_specs(prefix)))
                    pr_dbg('override spec -> :', D(override_spec))
                    if merge_raw:
                        Spec.merge_raw(self.get_specs(prefix), override_spec)
                    else:
                        Spec.merge(self.get_specs(prefix), override_spec)
                    pr_dbg('override merged -> :', D(self.get_specs(prefix)))

        if self.override_env + '_JSON' in os.environ:
            _override_env_str=os.environ.get(self.override_env + '_JSON')
            pr_dbg(_override_env_str)
            if _override_env_str:
                try:
                    override = json.loads(_override_env_str)
                except ValueError as detail:
                    pr_err("Error in %s: " % (self.override_env+'_JSON'), detail)
                    sys.exit(1)

                # Normalizes local keys before applying overrides
                Spec._normalize(self.get_specs(prefix), ['.'])

                pr_dbg('base spec -> :', D(self.get_specs(prefix)))
                pr_dbg('override spec -> :', D(override))
                if merge_raw:
                    Spec.merge_raw(self.get_specs(prefix), override)
                else:
                    Spec.merge(self.get_specs(prefix), override)
                pr_dbg('override merged -> :', D(self.get_specs(prefix)))

    def dump(self):
        pr(2, json.dumps(self.specs, sort_keys=True, indent=4, separators=(',', ': ')))

class SwSpec(Spec):
    """
    SW Spec Class (derived fom Spec)

    Handles SW specifics such as "compatible" keyword and implicit inheritance
    between 'default' node and non-default nodes
    """
    def __init__(self, **args):
        base_args = copy.copy(args)
        base_args['skip_process'] = True
        self.reserved_keys_sw = ['.', 'compatible', 'hide']
        super(SwSpec, self).__init__(**base_args)

        # Full spec only
        # Handle SW spec (implicit inheritance from default, compatible)

        if self.full_spec:
            for spec_id in self.specs.keys():
                # skip SW-specific processing if it's a reference
                if Spec.is_reference(spec_id): continue
                local_keys = self.specs[spec_id].get('.',[])

                # Handle compatible
                if 'compatible' in self.specs[spec_id]:
                    for c in self.specs[spec_id]['compatible']:
                        pr_dbg('Adding compat:' + c)
                        self.specs[c] = self.specs[spec_id]

                if 'default' in self.specs[spec_id]:
                    spec_default = copy.deepcopy(self.specs[spec_id]['default'])
                else:
                    continue

                pr_dbg('tnspec id ', spec_id)
                for cfg in self.specs[spec_id]:
                    if not isinstance(self.specs[spec_id][cfg], collections.Mapping): continue
                    if cfg in self.reserved_keys_sw: continue
                    if cfg == 'default': continue
                    cfg_spec = copy.deepcopy(spec_default)
                    pr_dbg('SwSpec processing: ' + spec_id + '.' + cfg)

                    Spec.merge(cfg_spec, self.specs[spec_id][cfg], local_keys)

                    self.specs[spec_id][cfg] = cfg_spec

        self.override_env = args.get('override_key', 'TNSPEC_SET_SW')
        skip_process = args.get('skip_process', False)
        if not skip_process:
            self.process()

    # sw.process
    def process(self, **options):
        # Apply override
        default = options.get('default',True)
        if options.get('apply_override', default):
            if self.full_spec:
                for spec_id in self.specs.keys():
                    if Spec.is_reference(spec_id): continue
                    for cfg in self.specs[spec_id]:
                        pr_dbg('sw.process -> specid:',spec_id, 'cfg:',cfg)
                        if not isinstance(self.specs[spec_id][cfg], collections.Mapping): continue
                        if cfg in self.reserved_keys_sw: continue
                        self.apply_override(spec_id + '.' + cfg, True)
            else:
                self.apply_override()

        options['apply_override'] = False

        super(SwSpec, self).process(**options)

class HwSpec(Spec):
    """
    HW Spec Class (derived fom Spec)
    """
    def _mac_generator(s):
        if not isinstance(s, collections.Mapping):
            return s
        prefix = s.get('prefix')
        if prefix == None or len(prefix.split(':')) != 3:
            prefix = '0E:04:4B'

        prefix = prefix.upper()

        # 'random' is the only method supported for now
        if s['method'] == 'random':
            pass

        addr = binascii.b2a_hex(os.urandom(3)).upper()
        addr = prefix + ':' + ':'.join([addr[i:i+2] for i in range(0,len(addr),2)])

        return addr

    hw_key_filters = \
        [ {'key' : 'wifi', 'fn': _mac_generator},
          {'key' : 'bt',   'fn': _mac_generator}]

    def __init__(self, **args):
        base_args = copy.copy(args)
        base_args['skip_process'] = True
        super(HwSpec, self).__init__(**base_args)

        self.override_env = args.get('override_key', 'TNSPEC_SET_HW')

        for m in HwSpec.hw_key_filters:
            self.register_filter(m)

        skip_process = args.get('skip_process', False)
        if not skip_process:
            self.process()

    def get_specs(self, query=''):
        return super(HwSpec, self).get_specs(query)

    # hw.process
    def process(self, **options):
        default=options.get('default', True)
        if options.get('apply_override', default):
            # add id and config fields if they are not found
            if self.full_spec:
                for e in self.specs.keys():
                    if Spec.is_reference(e):
                        continue
                    if 'id' not in self.specs[e]:
                        pr_dbg("adding a new id : ", e)
                        self.specs[e]['id'] = e
                    if 'config' not in self.specs[e]:
                        self.specs[e]['config'] = 'default'
                    pr_dbg('hw.process -> specid:', self.specs[e]['id'],
                                         'cfg:', self.specs[e]['config'])
                    self.apply_override(e, True)
            else:
                self.apply_override()

        options['apply_override'] = False
        super(HwSpec, self).process(**options)

# Go pretty :)
class bcolors(object):
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''

def main(cmds):
    commands = \
        {
            'nct'   : {'cls': CmdNCT},
            'spec'  : {'cls': CmdSpec},
            'help'  : {'cls': CmdHelp}
        }

    # set arguments for each method
    commands['help']['init'] = [commands]
    commands['help']['help'] = [commands]

    cmd = cmds[0]
    if cmd not in commands:
        command_failed()
        pr_err("Error: unknown command: " + cmd)
        CmdHelp.usage(2)
        sys.exit(1)

    cmdobj = commands[cmd]['cls'](*tuple(commands[cmd].get('init', [])))
    ret = cmdobj.process(cmds[1:])
    if ret:
        command_failed()
        pr_err("Error: tnspec %s %s: %s" %
                (cmd, cmds[1] if len(cmds) > 1 else '', ret))
        cmdobj.help(2, *tuple(commands[cmd].get('help',[])))
        sys.exit(1)
    sys.exit(0)

def split_cmds():
    # split commands and args. find the first occurence of a string starting
    # with '-'
    global g_argv_copy
    g_argv_copy = cmds = sys.argv[1:]
    options = []

    for i in range(len(g_argv_copy)):
        if len(g_argv_copy[i]) and g_argv_copy[i][0] == '-':
            options = g_argv_copy[i:]
            cmds = g_argv_copy[:i]
            break

    return (cmds, options)

if __name__ == "__main__":
    (cmds, options) = split_cmds()
    if len(cmds) == 0:
        CmdHelp.usage(2)
        sys.exit(1)
    # set options (-o, --options)
    set_options(options)
    main(cmds)
