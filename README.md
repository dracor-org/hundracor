# HunDraCor

The Hungarian Drama Corpus (HunDraCor) is based on the
[ELTE Drama Corpus](https://github.com/ELTE-DH/drama-corpus):

Szemes Botond – Bajzát Tímea – Fellegi Zsófia – Kundráth Péter – Horváth Péter –
Indig Balázs – Dióssy Anna – Hegedüs Fanni – Pantyelejev Natali – Sziráki
Sarolta – Vida Bence – Kalmár Balázs – Palkó Gábor 2022. Az ELTE
Drámakorpuszának létrehozása és lehetőségei. In: Tick József – Kokas Károly –
Holl András (szerk.): Valós térben – Az online térért: Networkshop 31: országos
konferencia. Budapest: HUNGARNET Egyesület. 170–178.

## Updating the corpus

We have implemented an integration workflow that allows to easily update
HunDraCor from the
[level1 files](https://github.com/ELTE-DH/drama-corpus/tree/main/level1) of the
ELTE source repo performing some minor transformations to make them DraCor
ready.

### Prerequisites

The XSLT workflow depends on the following tools

- [saxon XSLT processor](https://www.saxonica.com/)
- [xmlformat XML document formatter](http://www.kitebird.com/software/xmlformat/xmlformat.html)

### XSLT Transformation

To update the entire corpus from the sources run the the `elte2dracor` script
like this (assuming you have cloned the
[ELTE-drama-corpus](https://github.com/dracor-org/ELTE-drama-corpus) repo to the
same parent directory as `hundracor`):

```sh
./elte2dracor ../ELTE-drama-corpus/level1/*.xml
```

You can also update individual files, for instance:

```sh
./elte2dracor ../ELTE-drama-corpus/level1/Madach_ACivilizator.xml
```
