-- Copyright (C) 2017 yushi studio <ywb94@qq.com>
-- Licensed to the public under the GNU General Public License v3.

module("luci.controller.shadowsocksr", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/shadowsocksr") then
		return
	end

         if nixio.fs.access("/usr/bin/ssr-redir") 
         then
         entry({"admin", "services", "shadowsocksr"},alias("admin", "services", "shadowsocksr", "client"),_("ShadowSocksR"), 10).dependent = true
         entry({"admin", "services", "shadowsocksr", "client"},arcombine(cbi("shadowsocksr/client"), cbi("shadowsocksr/client-config")),_("SSR Client"), 10).leaf = true
         elseif nixio.fs.access("/usr/bin/ssr-server") 
         then 
         entry({"admin", "services", "shadowsocksr"},alias("admin", "services", "shadowsocksr", "server"),_("ShadowSocksR"), 10).dependent = true
         else
          return
         end  
	

	if nixio.fs.access("/usr/bin/ssr-server") then
	entry({"admin", "services", "shadowsocksr", "server"},arcombine(cbi("shadowsocksr/server"), cbi("shadowsocksr/server-config")),_("SSR Server"), 20).leaf = true
	end
		

	entry({"admin", "services", "shadowsocksr", "status"},cbi("shadowsocksr/status"),_("Status"), 30).leaf = true
	entry({"admin", "services", "shadowsocksr", "check"}, call("check_status"))

	
end

function check_status()
local set ="wget --spider --quiet -T3 -t1 www." .. luci.http.formvalue("set") .. ".com"
if luci.sys.call(set) == 0 then
retstring ="0"
else
retstring ="1"
end	
luci.http.prepare_content("application/json")
luci.http.write_json({ ret=retstring })
end

