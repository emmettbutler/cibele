import argparse
import os
import subprocess
try:
    import ConfigParser as configparser
except ImportError:
    import configparser

def write_entry_point():
    name = args.mainclass[0].lower()
    entry_point_class = "{}main".format(name)

    with open("src/{}.as".format(entry_point_class), "w") as f:
        f.write(
"""
package {{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="{preloader_class}")]

    public class {entry_point_class} extends GameMain {{
        public function {entry_point_class}(){{
            super(640, 480, {main_class}, 1);
        }}
    }}
}}
""".format(preloader_class="{}_loader".format(name),
           entry_point_class=entry_point_class,
           main_class=args.mainclass[0]))
    return entry_point_class


def write_preloader():
    name = args.mainclass[0].lower()
    entry_point_class = "{}main".format(name)
    preloader_class = "{}_loader".format(name)

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


def compile_main(entry_point_class, libpath, debug_level):
    stacktraces = "true"
    omit_trace = "false"
    debug = "true"
    debug_flag = "true"
    if debug_level == "test":
        debug_flag = "false"
    elif debug_level == "release":
        debug_flag = "false"
        omit_trace = "true"
        stacktraces = "false"
        debug = "false"
    command = ["mxmlc", "src/{entry_point_class}.as".format(entry_point_class=entry_point_class), "-o",
               "src/{entry_point_class}.swf".format(entry_point_class=entry_point_class),
               "-use-network=false", "-verbose-stacktraces={}".format(stacktraces),
               "-compiler.include-libraries", libpath,
               "-static-link-runtime-shared-libraries",
               "-debug={}".format(debug),
               "-omit-trace-statements={}".format(omit_trace),
               "-define=CONFIG::debug,{}".format(debug_flag)]
    print " ".join(command)
    subprocess.check_call(command)
    return "src/{entry_point_class}.swf".format(entry_point_class=entry_point_class)


def get_conf_path(entry_point_class):
    return "{}.xml".format(entry_point_class)


def write_conf_file(swf_path, entry_point_class, main_class):
    conf_path = get_conf_path(entry_point_class)
    with open(conf_path, "w") as f:
        f.write(
"""
<application xmlns="http://ns.adobe.com/air/application/3.1">
    <id>com.starmaid.Cibele</id>
    <versionNumber>1.0</versionNumber>
    <filename>{main_class}</filename>
    <initialWindow>
        <content>{swf_path}</content>
        <visible>true</visible>
        <width>640</width>
        <height>480</height>
    </initialWindow>
</application>
""".format(main_class=main_class, swf_path=swf_path)
        )
    return conf_path


def run_main(conf_file):
    command = "adl -runtime /Library/Frameworks {conf_path}".format(conf_path=conf_file)
    print command
    subprocess.call(command.split())


def package_application(entry_point_class):
    command = "adt -package -storetype pkcs12 -keystore cibelecert.pfx CibeleBeta.air {entry_point_class}.xml src/{entry_point_class}.swf assets".format(entry_point_class=entry_point_class)
    print command
    subprocess.call(command.split())


def copy_path_files():
    command = ["cp", os.path.expanduser("~/Library/Preferences/com.starmaid.Cibele/Local Store/ikuturso_path.txt"), "assets"]
    print " ".join(command)
    subprocess.call(command)


def main():
    libpath = args.libpath[0]

    copy_path_files()
    if args.copy_path:
        return

    entry_point_class = write_entry_point()

    if args.run_only:
        run_main(get_conf_path(entry_point_class))
    else:
        preloader_class = write_preloader()
        swf_path = compile_main(entry_point_class, libpath, args.debug_level[0])
        conf_path = write_conf_file(swf_path, entry_point_class, args.mainclass[0])

        if args.package:
            package_application(entry_point_class)
        else:
            run_main(conf_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compile Cibele")
    parser.add_argument('--mainclass', '-m', metavar="MAINCLASS", type=str,
                        default="", nargs=1,
                        help="The main FlxState class to use")
    parser.add_argument('--libpath', '-l', metavar="LIBPATH", type=str,
                        nargs=1,
                        help="The name of the flex directory in /opt")
    parser.add_argument('--config', '-c', metavar="CONFIG", type=str,
                        default="settings.ini", nargs=1,
                        help="The config file to use")
    parser.add_argument('--debug_level', '-d', metavar="DBGLEVEL", type=str,
                        default=["test"], nargs=1,
                        help="Debug level to compile under. One of [debug|test|release]")
    parser.add_argument('--package', '-p', action="store_true",
                        help="Build an Adobe AIR application")
    parser.add_argument('--copy_path', '-a', action="store_true",
                        help="Copy editor path files to source control")
    parser.add_argument('--run_only', '-r', action="store_true",
                        help="Don't compile, just run")
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config)

    if not args.__dict__.get("libpath"):
        args.libpath = [config.get("compile", "libpath")]
    if not args.__dict__.get("mainclass"):
        args.libpath = config.get("compile", "mainclass")

    if args.mainclass and args.mainclass[0]:
        main()
