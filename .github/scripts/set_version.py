import io,sys,re
p='pubspec.yaml'
s=open(p,'r',encoding='utf-8').read()
s=re.sub(r'(?m)^version:.*$',f"version: {sys.argv[1]}",s, count=1)
open(p,'w',encoding='utf-8').write(s)
print("patched pubspec.yaml")
