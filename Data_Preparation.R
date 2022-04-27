library(readxl)
library(dplyr)
library(tidyr)

dati <- read_excel("/Users/elisaMacBook/Desktop/Titanic.xlsx")

#DATA CLEANING
#ho un dataset con alcuni valori NA, li devo sostituire con 0
#la funzione mutate indica dove si vogliono applicare le funzioni
#across indica solo per le colonne numeriche/character
#replace_na è una funzione della libreria tidyr che sostituisce i na value con quello che si vuole, in questo caso 0
dati_puliti <-  mutate(dati, 
                       across(where(is.numeric), replace_na, 0),
                       across(where(is.character), replace_na, "0"))

#DATA INTEGRATION
#si vuole unire al set di dati precedente un nuovo dataset
#si usa la funzione rbind perchè bisogna aggiungere le righe del nuovo dataset a quello esistente
#se invece si avevano nuove caratteristiche dei dati già in possesso, quindi nuove colonne, bisognava usare cbind
nuovi_dati <- read_excel("/Users/elisaMacBook/Desktop/Titanic_nuovo.xlsx")

dati_totali <- rbind(dati_puliti, nuovi_dati)

#DATA TRANSFORMATION
#eliminazione dei campioni che non hanno età
dati_trasformati <- dati[dati$Age != "",]
dati_trasformati <- dati_trasformati[!is.na(dati_trasformati$Age),]

#feature engeneering - creazione di nuove variabili
#è importante osservare il dataset e capire se è possibile calcolare nuove caratteristiche da quelle esistenti
#in questo caso è possibile creare una combinazione lineare delle variabili SibSp e Parch, 
#per trovare il numero di componenti della famiglia di ogni persona
#è importante considerarlo se si vuole costruire, ad esempio, un modello predittivo sulla sopravvivenza dei passeggeri
#una persona che viaggia da sola ha più probabilità di salvarsi?
#una persona con famiglia potrebbe cedere il suo posto sulla scialuppa di salvataggio a un familiare?
dati$family_size <- dati %>% transmute(family_size = SibSp + Parch)

#DATA REDUCTION
#eliminazione della colonna dei nomi dei passeggeri, in una analisi statistica o di ML porta poca informazione
dati_ridotti <- dati_puliti[,-4]

#selezione casuale delle righe per costruire un campione dei dati di partenza
righe_campione <- sample(nrow(dati_puliti), nrow(dati_puliti)*0.8)
dati_campione <- dati_puliti [righe_campione,]

