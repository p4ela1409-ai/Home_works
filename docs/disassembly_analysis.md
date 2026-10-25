movl $0, -4(%rbp)
movl $1, -8(%rbp)
jmp .L2
.L3:
movl -8(%rbp), %eax
addl %eax, -4(%rbp)
addl $1, -8(%rbp)
.L2:
cmpl $10, -8(%rbp)
jle .L3
movl -4(%rbp), %eax
    логика:
movl $0, -4(%rbp) — аккумулятор acc = 0 
movl $1, -8(%rbp) — счётчик i = 1 
jmp .L2 — переход к проверке условия
.L3 — тело цикла: %eax = i, acc += %eax, i += 1.
.L2 — проверка: cmp i, 10; jle .L3 — пока i <= 10, повторять тело.
movl -4(%rbp), %eax — вернуть acc в %eax
Итог: сумма чисел от 1 до 10 = 55.
    восстановленный код:
acc = 0
i = 1 
while i <= 10:
    acc += i
    i += 1
