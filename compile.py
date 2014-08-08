import argparse
import subprocess

agrs = None


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

    public class {entry_point_class} extends FlxGame{{
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


def compile_main(entry_point_class, libpath):
    command = ["mxmlc", "src/{entry_point_class}.as".format(entry_point_class=entry_point_class), "-o",
               "src/{entry_point_class}.swf".format(entry_point_class=entry_point_class),
               "-use-network=false", "-verbose-stacktraces=true",
               "-compiler.include-libraries", libpath,
               "-static-link-runtime-shared-libraries"]
    subprocess.check_call(command)
    return "src/{entry_point_class}.swf".format(entry_point_class=entry_point_class)


def write_conf_file(swf_path, entry_point_class, main_class):
    conf_path = "{}.xml".format(entry_point_class)
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
    subprocess.call(command.split())


def main():
    libpath = args.libpath[0]

    entry_point_class = write_entry_point()
    preloader_class = write_preloader()
    swf_path = compile_main(entry_point_class, libpath)
    conf_path = write_conf_file(swf_path, entry_point_class, args.mainclass[0])
    run_main(conf_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compile Cibele")
    parser.add_argument('--mainclass', '-m', metavar="MAINCLASS", type=str,
                        default="", nargs=1,
                        help="The main FlxState class to use")
    parser.add_argument('--libpath', '-l', metavar="LIBPATH", type=str,
                        default=["opt/flex/frameworks/libs/air/airglobal.swc"], nargs=1,
                        help="The name of the flex directory in /opt")
    args = parser.parse_args()

    if args.mainclass and args.mainclass[0]:
        main()
