def process_transaction(user_id, amount, db_connection):
    log_entry = "Start processing"
    if amount > 0:
        status = "approved"
        balance = get_balance(user_id)
        new_balance = balance - amount
        update_balance(user_id, new_balance) 
    log_entry = "Transaction finished with status: " + status
    file = open("audit_log.txt", "w")
    file.write(log_entry)
    return status
  
  переменная  'log_entry':
def: строка 2 (log_entry = "Start processing")
use: строка 8 (log_entry = "Transaction finished with status: " + status)
use: строка 10 (file.write(log_entry))
  переменная  amount:
def: строка 3 (if amount > 0:)
use: строка 6 (new_balance = balance - amount)
  переменная status:
def: строка 4 ( status = "approved")
use: строка 8 (log_entry = "Transaction finished with status: " + status)
use: строка 11 (return status)
  переменная  balance:
def: строка 5 (balance = get_balance(user_id))
use: строка 6 (new_balance = balance - amount)
  переменная  new_balance:
def: строка 6 (new_balance = balance - amount)
use: строка 7 (update_balance(user_id, new_balance))
  переменная file:
def: строка 9 (file = open("audit_log.txt", "w"))
use:строка 10 (file.write(log_entry))

Выявление дефектов методом DFA:
  1. Использование неинициализированной переменной (status):
     Строка 11 (return status), условие: amount <= 0. Def на строке 4 не выполняется, а use на строке 11 выполняется всегда от сюда: UnboundLocalError: local variable 'status' referenced before assignment. Синтаксический линтер это не ловит, т.к. синтаксис корректен.
  2. Мёртвое присваивание (Dead Store: log_entry):
     Строка 2: log_entry = "Start processing" (значение никогда не читается, т.к. на строке 8 переменная перезаписывается до первого чтения. так же: если бы amount <= 0, то log_entry из стр. 2 тоже не попал бы в файл (файл вообще не открывается).
  3. Утечка ресурса (Resource Leak: file):
     Строка 9: file = open(...) — дескриптор не закрывается. Данные могут не сброситься на диск (буферизация).
