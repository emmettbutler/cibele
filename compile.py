import argparse
import datetime as dt
import os
import subprocess
try:
    import ConfigParser as configparser
except ImportError:
    import configparser


def _get_mainclass():
    main_classpath = args.mainclass[0]
    main_class = main_classpath.split('.')[-1]
    if '.' not in main_classpath:
        main_classpath = "com.starmaid.Cibele.states.{}".format(main_classpath)
    return main_class, main_classpath


def write_entry_point():
    main_class, main_classpath = _get_mainclass()
    entry_point_class = "{}main".format(main_class.lower())

    with open("src/{}.as".format(entry_point_class), "w") as f:
        f.write(
"""
package {{
    import {main_classpath};
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="{preloader_class}")]

    public class {entry_point_class} extends GameMain {{
        public function {entry_point_class}(){{
            super(640, 480, {main_class}, 1);
        }}
    }}
}}
""".format(preloader_class="{}_loader".format(main_class.lower()),
           entry_point_class=entry_point_class,
           main_class=main_class,
           main_classpath=main_classpath))
    return entry_point_class


def write_preloader():
    main_class, main_classpath = _get_mainclass()
    entry_point_class = "{}main".format(main_class.lower())
    preloader_class = "{}_loader".format(main_class.lower())

    with open("src/{}.as".format(preloader_class), "w") as f:
        f.write(
"""
package
{{
    import org.flixel.system.FlxPreloader;
    public class {preloader_class} extends FlxPreloader {{
        public function {preloader_class}() {{
            className = "{entry_point_class}";
            super();
        }}
    }}
}}
""".format(preloader_class=preloader_class,
           entry_point_class=entry_point_class))
    return preloader_class


def compile_main(entry_point_class, libpath, debug_level, mute=False):
    stacktraces = "true"
    omit_trace = "false"
    debug = "true"
    debug_flag = "true"
    test_flag = "true"
    if debug_level == "test":
        debug_flag = "false"
        test_flag = "true"
    elif debug_level == "release":
        debug_flag = "false"
        omit_trace = "true"
        stacktraces = "false"
        debug = "false"
        test_flag = "false"
    swfpath = "src/{entry_point_class}{ts}.swf".format(
        entry_point_class=entry_point_class,
        ts="")
    command = ["amxmlc", "src/{entry_point_class}.as".format(entry_point_class=entry_point_class), "-o",
               swfpath,
               "-use-network=false", "-verbose-stacktraces={}".format(stacktraces),
               "-compiler.include-libraries", libpath,
               "-debug={}".format(debug),
               "-omit-trace-statements={}".format(omit_trace),
               "-define=CONFIG::debug,{}".format(debug_flag),
               "-define=CONFIG::test,{}".format(test_flag),
               "-define=CONFIG::mute,{}".format("true" if mute else "false")]
    print " ".join(command)
    subprocess.check_call(command)
    return swfpath


def get_conf_path(entry_point_class):
    return "{}.xml".format(entry_point_class)


def write_conf_file(swf_path, entry_point_class, version_id):
    conf_path = get_conf_path(entry_point_class)
    with open(conf_path, "w") as f:
        f.write(
"""
<application xmlns="http://ns.adobe.com/air/application/{version_id}">
    <id>com.starmaid.Cibele</id>
    <versionNumber>1.0</versionNumber>
    <filename>CibeleBeta-{ts}</filename>
    <initialWindow>
        <content>{swf_path}</content>
        <visible>true</visible>
        <width>640</width>
        <height>480</height>
    </initialWindow>
</application>
""".format(version_id=version_id,
           ts=dt.datetime.now().strftime('%Y.%m.%d.%H.%M.%S'),
           swf_path=swf_path)
        )
    return conf_path


def run_main(conf_file, runtime):
    if runtime:
        runtime = "-runtime {}".format(runtime)
    command = "adl {runtime} {conf_path}".format(runtime=runtime, conf_path=conf_file)
    print command
    subprocess.call(command.split())


def package_application(entry_point_class, swf_path, platform="air"):
    """
    To generate cibelecert.pfx:
        adt -certificate -cn SelfSign -ou QE -o "Star Maid Games" -c US 2048-RSA cibelecert.pfx AmanoJyakku!
    """
    outfile = "CibeleBeta.air"
    target = ""
    if platform == "mac":
        target = "-target bundle"
        outfile = "CibeleBeta.app"
    command = "adt -package -storetype pkcs12 -keystore cibelecert.pfx {target} {outfile} {entry_point_class}.xml {swf_path} assets".format(
        entry_point_class=entry_point_class, swf_path=swf_path, target=target, outfile=outfile)
    print command
    subprocess.call(command.split())


def main():
    libpath = args.libpath[0]

    if args.copy_path:
        return

    entry_point_class = write_entry_point()

    if args.run_only:
        run_main(get_conf_path(entry_point_class), args.runtime[0])
    else:
        preloader_class = write_preloader()
        swf_path = compile_main(entry_point_class.split('.')[-1], libpath,
                                args.debug_level[0], mute=args.mute)
        conf_path = write_conf_file(swf_path, entry_point_class, args.version_id[0])

        if args.package:
            package_application(entry_point_class, swf_path, platform=args.platform)
        else:
            run_main(conf_path, args.runtime[0])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compile Cibele")
    parser.add_argument('--mainclass', '-m', metavar="MAINCLASS", type=str,
                        default="", nargs=1,
                        help="The main FlxState class to use")
    parser.add_argument('--libpath', '-l', metavar="LIBPATH", type=str,
                        nargs=1,
                        help="The name of the flex directory in /opt")
    parser.add_argument('--version_id', '-v', metavar="VERSION_ID", type=str,
                        nargs=1, default=["3.1"],
                        help="The xml namespace version to compile against")
    parser.add_argument('--config', '-c', metavar="CONFIG", type=str,
                        default="settings.ini", nargs=1,
                        help="The config file to use")
    parser.add_argument('--debug_level', '-d', metavar="DBGLEVEL", type=str,
                        default=["test"], nargs=1,
                        help="Debug level to compile under. One of [debug|test|release]")
    parser.add_argument('--package', '-p', action="store_true",
                        help="Build an executable")
    parser.add_argument('--mute', '-e', action="store_true",
                        help="Mute all sounds in this build")
    parser.add_argument('--platform', '-t', type=str, default="air",
                        help="The platform for which to build an executable (mac | air)")
    parser.add_argument('--copy_path', '-a', action="store_true",
                        help="Copy editor path files to source control")
    parser.add_argument('--run_only', '-r', action="store_true",
                        help="Don't compile, just run")
    parser.add_argument('--runtime', '-u', metavar="RUNTIME", type=str,
                        default=[""], nargs=1,
                        help="The location of the Adobe AIR runtime")
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config)

    if not args.__dict__.get("libpath"):
        args.libpath = [config.get("compile", "libpath")]
    if not args.__dict__.get("mainclass"):
        args.libpath = config.get("compile", "mainclass")

    if args.mainclass and args.mainclass[0]:
        main()
