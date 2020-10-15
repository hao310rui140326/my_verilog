#def foo():
#    print("starting...")
#    while True:
#        res = yield 4
#        print("res:",res)
#
#g = foo()
#print(next(g))
#print("*"*20)
#print(next(g))

#def fun_inner():
#    i = 0
#    while True:
#        i = yield i
#
#def fun_outer():
#    a = 0
#    b = 1
#    inner = fun_inner()
#    inner.send(None)
#    while True:
#        a = inner.send(b)
#        b = yield a
#
#if __name__ == '__main__':
#    outer = fun_outer()
#    outer.send(None)
#    for i in range(5):
#        print(outer.send(i))

def fun_inner():
    i = 0
    while True:
        i = yield i

def fun_outer():
    yield from fun_inner()

if __name__ == '__main__':
    outer = fun_outer()
    outer.send(None)
    for i in range(5):
        print(outer.send(i))
