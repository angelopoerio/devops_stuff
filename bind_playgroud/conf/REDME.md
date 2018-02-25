# README
A sample configuration for bind9 for an authoritative name server for the domain "example.org". Recursive queries are disabled.

# How to run
```bash
named -g -c named.conf
```

query with:
```bash
dig @127.0.0.1 www.exampleo.org
```

Sample output when trying to resolve an external domain:
```bash
25-Feb-2018 21:39:33.961 client 127.0.0.1#38699 (www.google.com): query (cache) 'www.google.com/A/IN' denied
```
