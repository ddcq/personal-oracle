import sys,re
raw = sys.stdin.read().strip().splitlines()
out=[]
for s in raw:
    s=s.strip()
    # remove common prefixes (feat:, fix:, chore:, ...)
    s=re.sub(r'^(feat|fix|chore|docs|perf|refactor|style|ci|test)(\(.+?\))?:\s*','',s, flags=re.I)
    s=s.strip()
    if not s:
        continue
    # capitalize first character
    s=s[0].upper()+s[1:] if len(s)>0 else s
    # ensure ends with period
    if not s.endswith(('.', '!', '?')):
        s = s + '.'
print("\n".join(out))
