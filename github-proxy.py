from mitmproxy import http
from urllib.parse import quote


# $env:GIT_SSL_NO_VERIFY="true"

def request(flow: http.HTTPFlow) -> None:
    # 只处理 foo.com 的请求
    if "github.com" in flow.request.host:
        # 获取原始完整URL
        original_url = flow.request.pretty_url
        
        # URL编码原始URL，使其可以作为路径的一部分
        encoded_url = original_url #quote(original_url, safe='')
        
        # 构建新URL
        new_host = "gh.llkk.cc"
        new_path = f"/{encoded_url}"
        
        # 修改请求
        flow.request.host = new_host
        #flow.request.scheme = "https"
        #flow.request.port = 443
        flow.request.path = new_path
        
        # 更新Host头部
        flow.request.headers["Host"] = new_host
        
        #print(f"重定向: {original_url} -> https://{new_host}{new_path}")
