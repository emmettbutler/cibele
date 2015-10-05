import argparse
import os
import shutil
import subprocess


APP_ID = 408120
MAC_DEPOT_ID = 408122
WINDOWS_DEPOT_ID = 408123


def prepare_app_mac(app_path, sdk_path):
    build_name = os.path.basename(app_path)
    dest_dir = "{sdk_path}tools/ContentBuilder/content".format(sdk_path=sdk_path)
    build_path = '{dest_dir}/{build_name}'.format(
        dest_dir=dest_dir,
        build_name=build_name)
    if os.path.exists(build_path):
        shutil.rmtree(build_path)

    command = "python {sdk_path}tools/ContentPrep.app/Contents/MacOS/contentprep.py --console --verbose --source {app_path}/ --dest {dest_dir} --appid {app_id} --nowrap".format(
        sdk_path=sdk_path,
        dest_dir=dest_dir,
        app_path=app_path,
        app_id=APP_ID)
    print command
    subprocess.call(command.split())


def build_app_vdf(sdk_path, description, platform):
    slash = "/" if platform == "mac" else "\\"
    trailing_slash = "" if platform == "mac" else "\\"
    filename = "{platform}_app_build.vdf".format(platform=platform)
    filepath = os.path.join(sdk_path, "tools", "ContentBuilder", "scripts", filename)
    with open(filepath, "w") as f:
        f.write(
"""
"appbuild"
{{
    "appid"    "{app_id}"
    "desc" "{description}" // description for this build
    "buildoutput" "..{slash}output{trailing_slash}" // build output folder for .log, .csm & .csd files, relative to location of this file
    "contentroot" "..{slash}content{trailing_slash}" // root content folder, relative to location of this file
    "setlive"    "" // branch to set live after successful build, non if empty
    "preview" "0" // to enable preview builds
    "local"    ""    // set to file path of local content server

    "depots"
    {{
        "{depot_id}" "{platform}_depot_build_{depot_id}.vdf"
    }}
}}
""".format(app_id=APP_ID,
           description=description,
           slash=slash,
           trailing_slash=trailing_slash,
           platform=platform,
           depot_id=MAC_DEPOT_ID if platform == "mac" else WINDOWS_DEPOT_ID))
    return filename


def build_depot_vdf(app_path, sdk_path, platform):
    build_name = os.path.basename(app_path)
    slash = "/" if platform == "mac" else "\\"
    trailing_slash = "" if platform == "mac" else "\\"
    vdf_name = "{platform}_depot_build_{depot_id}.vdf".format(
        depot_id=MAC_DEPOT_ID if platform == "mac" else WINDOWS_DEPOT_ID,
        platform=platform)
    filename = os.path.join(sdk_path, "tools", "ContentBuilder", "scripts", vdf_name)
    with open(filename, "w") as f:
        f.write(
"""
"DepotBuildConfig"
{{
    "DepotID" "{depot_id}"
    "ContentRoot"    "..{slash}content{trailing_slash}"
  "FileMapping"
  {{
    "LocalPath" "*"
    "DepotPath" "."
    "recursive" "1"
  }}
  "FileProperties"
  {{
    "LocalPath" "{build_name}"
    "Attributes" "executable"
  }}
  "FileExclusion" "*.pdb"
}}
""".format(app_id=APP_ID,
           slash=slash,
           trailing_slash=trailing_slash,
           build_name=build_name,
           depot_id=MAC_DEPOT_ID if platform == "mac" else WINDOWS_DEPOT_ID))


def upload_build(sdk_path, platform, app_vdf, steam_uname, steam_passwd):
    exe = "builder_osx/steamcmd.sh" if platform == "mac" else "builder\steamcmd.exe"
    vdf_path = os.path.join("..", "scripts", app_vdf)
    command = "{exe} +login {steam_uname} {steam_passwd} +run_app_build_http {vdf_path} +quit".format(
        sdk_path=sdk_path,
        vdf_path=vdf_path,
        exe=exe,
        steam_uname=steam_uname,
        steam_passwd=steam_passwd)
    print command
    subprocess.call(command.split(),
                    cwd=os.path.join(sdk_path, "tools", "ContentBuilder"),
                    shell=platform == "windows")


def move_app(app_path, sdk_path):
    app_name = os.path.basename(app_path)
    print "Copying app to steamworks sdk"
    shutil.copytree(app_path, os.path.join(sdk_path, "tools", "ContentBuilder", "content", app_name))


def main():
    description = " ".join(args.description)
    if args.platform == "mac":
        prepare_app_mac(args.app_path, args.sdk_path)
    elif args.platform == "windows":
        move_app(args.app_path, args.sdk_path)
    app_vdf = build_app_vdf(args.sdk_path, description, args.platform)
    build_depot_vdf(args.app_path,
                    args.sdk_path,
                    args.platform)
    upload_build(args.sdk_path, args.platform, app_vdf,
                 args.steam_uname, args.steam_passwd)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compile Cibele")
    parser.add_argument('--sdk_path', '-s', metavar="SDKPATH", type=str,
                        default="/opt/steamworks_sdk/",
                        help="The path to the steam sdk directory")
    parser.add_argument('--app_path', '-a', metavar="APPPATH", type=str,
                        required=True,
                        help="The path to the executable file to upload")
    parser.add_argument('--description', '-d', metavar="DESCRIPTION", type=str,
                        nargs="+", default=["Build update"],
                        help="A description of this build's changes")
    parser.add_argument('--platform', '-t', type=str, default="mac",
                        help="The platform for which to upload this build (windows | mac)")
    parser.add_argument('--steam_uname', '-u', metavar="UNAME", type=str,
                        required=True, help="Steam username")
    parser.add_argument('--steam_passwd', '-p', metavar="PASSWD", type=str,
                        required=True, help="Steam password")
    args = parser.parse_args()

    main()
