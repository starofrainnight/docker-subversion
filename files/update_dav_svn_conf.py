import os
import os.path

location_prefix = "/svn"
parent_prefix = "/var/lib/svn"

dav_conf_file_path = "/etc/apache2/mods-available/dav_svn.conf"
origin_content = ""
if os.path.exists(dav_conf_file_path):
    with open(dav_conf_file_path, "rb") as src_file:
        origin_content = src_file.read()
        src_file.close()

template = """
<Location %s>
	DAV svn
	SVNParentPath %s

	AuthzSVNAccessFile /etc/apache2/dav_svn/authz

	Satisfy any
	Require valid-user
	AuthType Basic
	AuthName "Subversion"
	AuthUserFile /etc/apache2/dav_svn/htpasswd
</Location>
"""

dst_contents = []

# Append the first level directory if it's not the repository
format_path = os.path.join(parent_prefix, "format")
if not os.path.exists(format_path):
    dst_contents.append(template % (location_prefix, parent_prefix))

for root, dirs, files in os.walk(parent_prefix):
    dont_visit_dirs = []
    for adir in dirs:
        adir_path = os.path.normpath(os.path.join(root, adir))
        format_path = os.path.join(adir_path, "format")
        svnserve_path = os.path.join(adir_path, "conf/svnserve.conf")
        if not (os.path.exists(format_path) and os.path.exists(svnserve_path)):
            dont_visit_dirs.append(adir)
            continue

        suffix_dir = adir_path[len(parent_prefix) + 1:]
        new_location = os.path.join(location_prefix, suffix_dir)
        new_parent = os.path.join(parent_prefix, suffix_dir)

        content = template % (new_location, new_parent)
        dst_contents.append(content)

    for adir in dont_visit_dirs:
        dirs.remove(adir)

content = "\n".join(dst_contents)

print("Origin content size : %s, New content size : %s" %
      (len(origin_content), len(content)))

if origin_content != content:
    with open(dav_conf_file_path, "wb") as dst_file:
        dst_file.write(content)

    print("New content different from origins! Overwroted.")
else:
    print("No new modifications needs to update.")
