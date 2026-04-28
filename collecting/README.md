### Presa dati da remoto

***

#### PRIMA DI FARE QUALUNQUE COSA: 
**CONTROLLARE CHE NON CI SIANO VECCHI FILE DI DATI CHIAMATI** `data_file.txt` **!!!!**  
  **SE CI SONO RINOMINARLI PERCHÉ IL PROGRAMMA LI SOVRASCRIVE!!!!!** 
  Workflow tipico: 
1. Definire nel modo giusto i nomi delle porte seriali e la durata della presa dati, stimandola sempre per eccesso;
2. Eseguire `init.m`: viene stabilita la connessione con gli strumenti (e costruita l'architettura del contenitore di dati);
3. Eseguire `delphi_visual.m`: viene avviato il processo di misura, i dati vengono salvati nella tabella e poi nel file. Si vede la curva percolativa in runtime!
4. Quando la curva percolativa è completata fare `ctrl + C` per fermare il programma, poi digitare l'istruzione alla fine di `delphi_visual.m` per stampare nel file la serie di dati;
5. Chiamare i file di dati nel modo giusto!!!! Nome convenzionale: `"nome substrato"_"numero deposizione"_data.txt`;
6. Committare almeno dopo ogni turno di labo, **ASSICURANDOSI CHE I FILE DI DATI ABBIANO NOMI ADATTI!!**. 