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
- [xmlformat XML document formatter](https://web.archive.org/web/20160929174540/http://www.kitebird.com/software/xmlformat/)
  (on macOS with homebrew you can `brew install xmlformat`)

### XSLT Transformation

To update the entire corpus from the sources simply run the the `elte2dracor`
script from the root directory of this repo:

```sh
./elte2dracor
```

This clones the
[ELTE-drama-corpus](https://github.com/dracor-org/ELTE-drama-corpus) repo and
runs the transformation for each file in its `level1` directory.

You can also update individual files, for instance:

```sh
./elte2dracor ./elte-drama-corpus/level1/Madach_ACivilizator.xml
```
