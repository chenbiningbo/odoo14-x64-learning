��    l      |  �   �      0	     1	  9   K	  -   �	  :   �	  -   �	  4   
  9   Q
  O   �
  1   �
  +     O   9  ;   �  I   �        +   0  "   \  +        �  >   �  !     ,   (  +   U  '   �  )   �  6   �  #   
  <   .  &   k  -   �  !   �  1   �  ?     &   T  !   {  =   �  "   �  (   �  z   '     �  #   �  \   �  +   8  0   d      �  2   �  @   �  B   *  4   m  G   �  &   �  -        ?     _  )   o  )   �  )   �     �  )   
  )   4  )   ^  )   �  )   �  )   �  )        0  V   M  )   �  )   �  )   �  ,   "  )   O  )   y  )   �  )   �  )   �  )   !  )   K  )   u  )   �  )   �  )   �  )     )   G  )   q  )   �  )   �  )   �  )     )   C  )   m  )   �  )   �  	   �  )   �  �     &   �  !   �  )   	     3  -   J     x     �  )   �     �  )   �     �  )   �      A     �   Z  W   �  X   ?  H   �  m   �  ?   O   �   �   Y   '!  V   �!  �   �!  m   �"  �   �"  7   �#  K   �#  8   '$  G   `$  5   �$  {   �$  A   Z%  a   �%  B   �%  ?   A&  ?   �&  h   �&  =   *'  t   h'  ?   �'  M   (  9   k(  `   �(     )  C   �)  =   �)  p   *  ;   y*  A   �*  �   �*  8   �+  D   �+  �   ",  U   �,  d   8-  2   �-  h   �-  �   9.  �   �.  h   h/  o   �/  I   A0  U   �0  0   �0     1  E   -1  6   s1  <   �1  -   �1  E   2  6   [2  F   �2  B   �2  H   3  :   e3  :   �3  ;   �3  �   4  8   �4  8   �4  ;   35  >   o5  G   �5  9   �5  4   06  4   e6  4   �6  7   �6  ;   7  >   C7  ;   �7  K   �7  E   
8  I   P8  A   �8  )   �8  )   9  )   09  .   Z9  )   �9  ,   �9  )   �9  ,   
:  )   7:     a:  D   v:  .  �:  [   �;  L   F<  4   �<  1   �<  `   �<     [=     m=  )   �=  	   �=  )   �=     �=  4   �=     8   T   d   O      `      @       J   _   Y   M   ,              A      "   ?   X   a         0   6         g   S       &                            +          P       \              /       i   <      !   b   >   R   	             2           ]             j          c      V       f   '          h            H   (           #   C   
       E   .       4   -   k   G   Q   U   7   ^       5       3   F   [       9       %          Z   l   I      *                  :               L       $       B       =   N       e       D       W   K       1   ;   )       

Values to be changed:

 
If these values seem acceptable, use -f to force reset.
 
Report bugs to <pgsql-bugs@postgresql.org>.
                    (zero in either value means no change)
   -?, --help       show this help, then exit
   -O OFFSET        set next multitransaction offset
   -V, --version    output version information, then exit
   -c XID,XID       set oldest and newest transactions bearing commit timestamp
   -e XIDEPOCH      set next transaction ID epoch
   -f               force update to be done
   -l WALFILE       force minimum WAL starting location for new write-ahead log
   -m MXID,MXID     set next and oldest multitransaction ID
   -n               no update, just show what would be done (for testing)
   -o OID           set next OID
   -x XID           set next transaction ID
  [-D] DATADIR      data directory
 %s resets the PostgreSQL write-ahead log.

 %s: OID (-o) must not be 0
 %s: WARNING: cannot create restricted tokens on this platform
 %s: cannot be executed by "root"
 %s: could not allocate SIDs: error code %lu
 %s: could not change directory to "%s": %s
 %s: could not close directory "%s": %s
 %s: could not create pg_control file: %s
 %s: could not create restricted token: error code %lu
 %s: could not delete file "%s": %s
 %s: could not get exit code from subprocess: error code %lu
 %s: could not open directory "%s": %s
 %s: could not open file "%s" for reading: %s
 %s: could not open file "%s": %s
 %s: could not open process token: error code %lu
 %s: could not re-execute with restricted token: error code %lu
 %s: could not read directory "%s": %s
 %s: could not read file "%s": %s
 %s: could not start process for command "%s": error code %lu
 %s: could not write file "%s": %s
 %s: could not write pg_control file: %s
 %s: data directory is of wrong version
File "%s" contains "%s", which is not compatible with this program's version "%s".
 %s: fsync error: %s
 %s: invalid argument for option %s
 %s: lock file "%s" exists
Is a server running?  If not, delete the lock file and try again.
 %s: multitransaction ID (-m) must not be 0
 %s: multitransaction offset (-O) must not be -1
 %s: no data directory specified
 %s: oldest multitransaction ID (-m) must not be 0
 %s: pg_control exists but has invalid CRC; proceed with caution
 %s: pg_control exists but is broken or wrong version; ignoring it
 %s: too many command-line arguments (first is "%s")
 %s: transaction ID (-c) must be either 0 or greater than or equal to 2
 %s: transaction ID (-x) must not be 0
 %s: transaction ID epoch (-e) must not be -1
 %s: unexpected empty file "%s"
 64-bit integers Blocks per segment of large relation: %u
 Bytes per WAL segment:                %u
 Catalog version number:               %u
 Current pg_control values:

 Data page checksum version:           %u
 Database block size:                  %u
 Database system identifier:           %s
 Date/time type storage:               %s
 First log segment after reset:        %s
 Float4 argument passing:              %s
 Float8 argument passing:              %s
 Guessed pg_control values:

 If you are sure the data directory path is correct, execute
  touch %s
and try again.
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID:          %u:%u
 Latest checkpoint's TimeLineID:       %u
 Latest checkpoint's full_page_writes: %s
 Latest checkpoint's newestCommitTsXid:%u
 Latest checkpoint's oldestActiveXID:  %u
 Latest checkpoint's oldestCommitTsXid:%u
 Latest checkpoint's oldestMulti's DB: %u
 Latest checkpoint's oldestMultiXid:   %u
 Latest checkpoint's oldestXID's DB:   %u
 Latest checkpoint's oldestXID:        %u
 Maximum columns in an index:          %u
 Maximum data alignment:               %u
 Maximum length of identifiers:        %u
 Maximum size of a TOAST chunk:        %u
 NextMultiOffset:                      %u
 NextMultiXactId:                      %u
 NextOID:                              %u
 NextXID epoch:                        %u
 NextXID:                              %u
 OldestMulti's DB:                     %u
 OldestMultiXid:                       %u
 OldestXID's DB:                       %u
 OldestXID:                            %u
 Options:
 Size of a large-object chunk:         %u
 The database server was not shut down cleanly.
Resetting the write-ahead log might cause data to be lost.
If you want to proceed anyway, use -f to force reset.
 Try "%s --help" for more information.
 Usage:
  %s [OPTION]... DATADIR

 WAL block size:                       %u
 Write-ahead log reset
 You must run %s as the PostgreSQL superuser.
 by reference by value newestCommitTsXid:                    %u
 off oldestCommitTsXid:                    %u
 on pg_control version number:            %u
 Project-Id-Version: pg_resetxlog (PostgreSQL current)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2017-08-23 14:45+0000
PO-Revision-Date: 2017-08-23 12:34+0300
Last-Translator: Alexander Lakhin <exclusion@gmail.com>
Language-Team: Russian <pgsql-ru-general@postgresql.org>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
 

Значения, которые будут изменены:

 
Если эти значения приемлемы, выполните сброс принудительно, добавив ключ -f.
 
Об ошибках сообщайте по адресу <pgsql-bugs@postgresql.org>.
                    (0 в любом из аргументов игнорируется)
   -?, --help       показать эту справку и выйти
   -O СМЕЩЕНИЕ      задать смещение следующей мультитранзакции
   -V, --version    показать версию и выйти
   -c XID,XID       задать старейшую и новейшую транзакции, несущие метку времени фиксации
   -e XIDEPOCH      задать эпоху в ID следующей транзакции
   -f               принудительное выполнение операции
   -l WALFILE       задать минимальное начальное положение WAL для нового
                   журнала предзаписи
   -m MXID,MXID     задать ID следующей и старейшей мультитранзакции
   -n               показать, какие действия будут выполнены, но не выполнять их
                   (для проверки)
   -o OID           задать следующий OID
   -x XID           задать ID следующей транзакции
  [-D] КАТ_ДАННЫХ   каталог данных
 %s сбрасывает журнал предзаписи PostgreSQL.

 %s: OID (-o) не должен быть равен 0
 %s: ПРЕДУПРЕЖДЕНИЕ: в этой ОС нельзя создавать ограниченные маркеры
 %s: программу не должен запускать root
 %s: не удалось подготовить структуры SID (код ошибки: %lu)
 %s: не удалось перейти в каталог "%s": %s
 %s: не удалось закрыть каталог "%s": %s
 %s: не удалось создать файл pg_control: %s
 %s: не удалось создать ограниченный маркер (код ошибки: %lu)
 %s: ошибка при удалении файла "%s": %s
 %s: не удалось получить код выхода от подпроцесса (код ошибки: %lu)
 %s: не удалось открыть каталог "%s": %s
 %s: не удалось открыть файл "%s" для чтения: %s
 %s: не удалось открыть файл "%s": %s
 %s: не удалось открыть маркер процесса (код ошибки: %lu)
 %s: не удалось перезапуститься с ограниченным маркером (код ошибки: %lu)
 %s: не удалось прочитать каталог "%s": %s
 %s: не удалось прочитать файл "%s": %s
 %s: не удалось запустить процесс для команды "%s" (код ошибки: %lu)
 %s: не удалось записать файл "%s": %s
 %s: не удалось записать файл pg_control: %s
 %s: каталог данных неверной версии
Файл "%s" содержит строку "%s", а ожидается версия программы "%s".
 %s: ошибка синхронизации с ФС: %s
 %s: недопустимый аргумент параметра %s
 %s: обнаружен файл блокировки "%s"
Возможно, сервер запущен? Если нет, удалите этот файл и попробуйте снова.
 %s: ID мультитранзакции (-m) не должен быть равен 0
 %s: смещение мультитранзакции (-O) не должно быть равно -1
 %s: каталог данных не указан
 %s: ID старейшей мультитранзакции (-m) не должен быть равен 0
 %s: pg_control существует, но его контрольная сумма неверна; продолжайте с осторожностью
 %s: pg_control испорчен или имеет неизвестную либо недопустимую версию; игнорируется...
 %s: слишком много аргументов командной строки (первый: "%s")
 %s: ID транзакции (-c) должен быть равен 0, либо больше или равен 2
 %s: ID транзакции (-x) не должен быть равен 0
 %s: эпоха ID транзакции (-e) не должна быть равна -1
 %s: файл "%s" оказался пустым
 64-битные целые Блоков в макс. сегменте отношений:    %u
 Байт в сегменте WAL:                  %u
 Номер версии каталога:                %u
 Текущие значения pg_control:

 Версия контрольных сумм страниц:      %u
 Размер блока БД:                      %u
 Идентификатор системы баз данных:     %s
 Формат хранения даты/времени:         %s
 Первый сегмент журнала после сброса:  %s
 Передача аргумента Float4:            %s
 Передача аргумента Float8:            %s
 Предполагаемые значения pg_control:

 Если вы уверены, что путь к каталогу данных правильный, выполните
  touch %s
и повторите попытку.
 NextMultiOffset послед. конт. точки:  %u
 NextMultiXactId послед. конт. точки:  %u
 NextOID последней конт. точки:        %u
 NextXID последней конт. точки:        %u:%u
 Линия времени последней конт. точки:  %u
 Режим full_page_writes последней к.т: %s
 newestCommitTsXid последней к. т.:    %u
 oldestActiveXID последней к. т.:      %u
 oldestCommitTsXid последней к. т.:    %u
 БД с oldestMulti последней к. т.:     %u
 oldestMultiXid последней конт. точки: %u
 БД с oldestXID последней конт. точки: %u
 oldestXID последней конт. точки:      %u
 Максимальное число столбцов в индексе: %u
 Макс. предел выравнивания данных:     %u
 Максимальная длина идентификаторов:   %u
 Максимальный размер порции TOAST:     %u
 NextMultiOffset:                      %u
 NextMultiXactId:                      %u
 NextOID:                              %u
 Эпоха NextXID:                        %u
 NextXID:                              %u
 БД с oldestMultiXid:                  %u
 OldestMultiXid:                       %u
 БД с oldestXID:                       %u
 OldestXID:                            %u
 Параметры:
 Размер порции большого объекта:       %u
 Сервер баз данных был остановлен некорректно.
Сброс журнала предзаписи может привести к потере данных.
Если вы хотите сбросить его, несмотря на это, добавьте ключ -f.
 Для дополнительной информации попробуйте "%s --help".
 Использование:
  %s [ПАРАМЕТР]... КАТ_ДАННЫХ

 Размер блока WAL:                     %u
 Журнал предзаписи сброшен
 Запускать %s нужно от имени суперпользователя PostgreSQL.
 по ссылке по значению newestCommitTsXid:                    %u
 выкл. oldestCommitTsXid:                    %u
 вкл. Номер версии pg_control:              %u
 