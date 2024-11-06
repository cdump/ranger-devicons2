#!/bin/bash
set -e

SRC_URL="https://raw.githubusercontent.com/nvim-tree/nvim-web-devicons/master/lua/nvim-web-devicons/icons-default.lua"

echo "Updating from ${SRC_URL}..."

curl -o icons-default.lua -s ${SRC_URL}

cat <<EOF | lua > icons.py
local function p(name, d)
    print(name .. ' = {')
    local keys = {}
    for k in pairs(d) do table.insert(keys, k) end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local v = d[k]
        print("  '" .. k .. "': '" .. v.icon .. "',")
    end
    print('}')
end

local d = loadfile('icons-default.lua')()

print('# vim: set fileencoding=utf-8')
print('# autogenerated with gen_icons.sh')
print('')
p('file_node_extensions', d.icons_by_file_extension)
p('file_node_exact_matches', d.icons_by_filename)
print([[
file_node_pattern_matches = {
  '.*jquery.*.js$'       : '',
  '.*angular.*.js$'      : '',
  '.*backbone.*.js$'     : '',
  '.*require.*.js$'      : '',
  '.*materialize.*.js$'  : '',
  '.*materialize.*.css$' : '',
  '.*mootools.*.js$'     : '',
  '.*vimrc.*'             : '',
  'Vagrantfile$'          : ''
}
]])
EOF
rm -f icons-default.lua

echo "Testing updated icons.py"
python icons.py

echo "Success!"
