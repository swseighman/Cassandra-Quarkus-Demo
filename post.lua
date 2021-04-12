-- example HTTP POST script which demonstrates setting the
-- HTTP method, body, and adding a header

wrk.method = "POST"
wrk.body   = "{\"name\": \"Apple\", \"Description\": \"red and tasty\"}"
wrk.headers["Content-Type"] = "application/json"
