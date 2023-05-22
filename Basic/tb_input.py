import os
import random

file_name = 'testbench.txt'

with open(file_name,'w') as f:
    for i in range(10):
        a1 = random.randint(0,15)
        b1 = random.randint(0,15)
        a2 = random.randint(0,15)
        b2 = random.randint(0,15)
        sel = random.randint(0,1)
        if sel == 1:
            sum = a2+b2
        else:
            sum = a1+b1
        if sum > 15:
            carry = 1
            sum-=16;
        else:
            carry = 0
        f.write(str(a1)+'\t'+str(a2)+'\t'+str(b1)+'\t'+str(b2)+'\t'+str(sel)+'\t'+str(sum)+'\t'+str(carry)+'\r\n')