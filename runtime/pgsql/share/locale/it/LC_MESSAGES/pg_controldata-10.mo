��    U      �  q   l      0  X   1  
   �     �  +   �  7   �        C   3  -   w  !   �      �  4   �     	  ,   -	  ,   Z	  )   �	  )   �	  )   �	  )   
  )   /
  )   Y
  )   �
  )   �
  )   �
  ,     )   .  )   X  ,   �  )   �  )   �  )     ,   -  )   Z  )   �  ,   �  )   �  )     )   /  )   Y  )   �  )   �  )   �  )     )   +  )   U  )     )   �  )   �  )   �  ,   '  )   T  ,   ~  ,   �  )   �  )     &   ,     S  )   [  �   �    L     \     i     r     �     �     �  )   �  )   �  )     )   ;     e     h     l  )   o  )   �  	   �     �     �     �  )   �     '     @  )   W  )   �     �  �  �  j   �  
          -   7  <   e  $   �  K   �  6     &   J  6   q  ;   �     �  2   �  2   '  /   Z  /   �  /   �  /   �  /     /   J  /   z  /   �  /   �  2   
  /   =  /   m  2   �  /   �  /      /   0  2   `  /   �  /   �  2   �  /   &  /   V  /   �  /   �  /   �  /     /   F  /   v  /   �  /   �  /     /   6  /   f  /   �  2   �  /   �  2   )   <   \   /   �   /   �   -   �   
   '!  /   2!  �   b!  >  B"     �#  
   �#  $   �#  "   �#     �#     $  /   $  /   B$  /   r$  /   �$     �$     �$     �$  /   �$  /   %     J%     Q%     o%     �%  /   �%     �%     �%  /   �%  /   !&     Q&     ?   >             5   U              .   G       P   B               7      0   1   T      =          4          K       8       E   !   F             2   N      M   :   )   +   L   "           (   -                       #   9   C      $           D      O             &   R       ;   I                       	   '   J       6              H             ,   *      %   <   A   S   @      
              Q   3   /        
If no data directory (DATADIR) is specified, the environment variable PGDATA
is used.

 
Options:
   %s [OPTION] [DATADIR]
   -?, --help     show this help, then exit
   -V, --version  output version information, then exit
  [-D] DATADIR    data directory
 %s displays control information of a PostgreSQL database cluster.

 %s: could not open file "%s" for reading: %s
 %s: could not read file "%s": %s
 %s: no data directory specified
 %s: too many command-line arguments (first is "%s")
 64-bit integers Backup end location:                  %X/%X
 Backup start location:                %X/%X
 Blocks per segment of large relation: %u
 Bytes per WAL segment:                %u
 Catalog version number:               %u
 Data page checksum version:           %u
 Database block size:                  %u
 Database cluster state:               %s
 Database system identifier:           %s
 Date/time type storage:               %s
 End-of-backup record required:        %s
 Fake LSN counter for unlogged rels:   %X/%X
 Float4 argument passing:              %s
 Float8 argument passing:              %s
 Latest checkpoint location:           %X/%X
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID:          %u:%u
 Latest checkpoint's PrevTimeLineID:   %u
 Latest checkpoint's REDO WAL file:    %s
 Latest checkpoint's REDO location:    %X/%X
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
 Min recovery ending loc's timeline:   %u
 Minimum recovery ending location:     %X/%X
 Mock authentication nonce:            %s
 Prior checkpoint location:            %X/%X
 Report bugs to <pgsql-bugs@postgresql.org>.
 Size of a large-object chunk:         %u
 Time of latest checkpoint:            %s
 Try "%s --help" for more information.
 Usage:
 WAL block size:                       %u
 WARNING: Calculated CRC checksum does not match value stored in file.
Either the file is corrupt, or it has a different layout than this program
is expecting.  The results below are untrustworthy.

 WARNING: possible byte ordering mismatch
The byte ordering used to store the pg_control file might not match the one
used by this program.  In that case the results below would be incorrect, and
the PostgreSQL installation would be incompatible with this data directory.
 by reference by value byte ordering mismatch in archive recovery in crash recovery in production max_connections setting:              %d
 max_locks_per_xact setting:           %d
 max_prepared_xacts setting:           %d
 max_worker_processes setting:         %d
 no off on pg_control last modified:             %s
 pg_control version number:            %u
 shut down shut down in recovery shutting down starting up track_commit_timestamp setting:       %s
 unrecognized status code unrecognized wal_level wal_level setting:                    %s
 wal_log_hints setting:                %s
 yes Project-Id-Version: pg_controldata (PostgreSQL) 10
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2017-05-22 07:47+0000
PO-Revision-Date: 2017-04-23 04:34+0100
Last-Translator: Daniele Varrazzo <daniele.varrazzo@gmail.com>
Language-Team: https://github.com/dvarrazzo/postgresql-it
Language: it
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-SourceCharset: utf-8
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 1.8.7.1
 
Se non viene specificata un directory per i dati (DATADIR) verrà usata la
variabile d'ambiente PGDATA.

 
Opzioni:
   %s [OPZIONE] [DATADIR]
   -?, --help     mostra questo aiuto ed esci
   -V, --version  mostra informazioni sulla versione ed esci
  [-D] DATADIR    directory dei dati
 %s mostra informazioni di controllo su un cluster di database PostgreSQL.

 %s: apertura del file "%s" per la lettura fallita: %s
 %s: lettura del file "%s" fallita: %s
 %s: non è stata specificata una directory per i dati
 %s: troppi argomenti di riga di comando (il primo è "%s")
 interi a 64 bit Posizione della fine del backup:            %X/%X
 Posizione dell'inizio del backup:           %X/%X
 Blocchi per ogni segmento grosse tabelle:   %u
 Byte per segmento WAL:                      %u
 Numero di versione del catalogo:            %u
 Versione somma di controllo dati pagine:    %u
 Dimensione blocco database:                 %u
 Stato del cluster di database:              %s
 Identificatore di sistema del database:     %s
 Memorizzazione per tipi data/ora:           %s
 Record di fine backup richiesto:            %s
 Falso contatore LSN per rel. non loggate:   %X/%X
 Passaggio di argomenti Float4:              %s
 passaggio di argomenti Float8:              %s
 Ultima posizione del checkpoint:            %X/%X
 NextMultiOffset dell'ultimo checkpoint:     %u
 NextMultiXactId dell'ultimo checkpoint:     %u
 NextOID dell'ultimo checkpoint:             %u
 NextXID dell'ultimo checkpoint:             %u:%u
 PrevTimeLineID dell'ultimo checkpoint:      %u
 File WAL di REDO dell'ultimo checkpoint:    %s
 Locazione di REDO dell'ultimo checkpoint:   %X/%X
 TimeLineId dell'ultimo checkpoint:          %u
 full_page_writes dell'ultimo checkpoint:    %s
 newestCommitTsXid dell'ultimo checkpoint:   %u
 oldestActiveXID dell'ultimo checkpoint:     %u
 oldestCommitTsXid dell'ultimo checkpoint:   %u
 DB dell'oldestMulti dell'ultimo checkpoint: %u
 oldestMultiXID dell'ultimo checkpoint:      %u
 DB dell'oldestXID dell'ultimo checkpoint:   %u
 oldestXID dell'ultimo checkpoint:           %u
 Massimo numero di colonne in un indice:     %u
 Massimo allineamento dei dati:              %u
 Lunghezza massima degli identificatori:     %u
 Massima dimensione di un segmento TOAST:    %u
 Timeline posiz. minimum recovery ending:    %u
 Posizione del minimum recovery ending:      %X/%X
 Finto nonce di autenticazione:              %s
 Posizione precedente del checkpoint:        %X/%X
 Puoi segnalare eventuali bug a <pgsql-bugs@postgresql.org>.
 Dimensione di un blocco large-object:       %u
 Orario ultimo checkpoint:                   %s
 Prova "%s --help" per maggiori informazioni.
 Utilizzo:
 Dimensione blocco WAL:                      %u
 ATTENZIONE: Il codice di controllo CRC calcolato non combacia con quello
memorizzato nel file. O il file è corrotto o ha un formato diverso da quanto
questo programma si aspetta. I risultati seguenti non sono affidabili.

 ATTENZIONE: possibile differenza nell'ordine dei byte
L'ordine dei byte usato per memorizzare il file pg_control potrebbe non
combaciare con quello usato da questo programma. In questo caso i risultati
seguenti non sarebbero corretti e l'installazione di PostgreSQL sarebbe
incompatibile con questa directory di dati.
 per riferimento per valore ordinamento dei byte non combaciante in fase di recupero di un archivio in fase di recupero da un crash in produzione Impostazione di max_connections:            %d
 Impostazione di max_locks_per_xact:         %d
 Impostazione di max_prepared_xacts:         %d
 Impostazione di max_worker_processes:       %d
 no disattivato attivato Ultima modifica a pg_control:               %s
 Numero di versione di pg_control:           %u
 spento arresto durante il ripristino arresto in corso avvio in corso Impostazione di track_commit_timestamp:     %s
 codice di stato sconosciuto wal_level sconosciuto Impostazione di wal_level:                  %s
 Impostazione di wal_log_hints:              %s
 sì 