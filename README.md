wGetCrawler
===========

wGetCrawler permet de récupérer un ensemble de données d'une page web en crawlant un site.

## Pré-requis

Ce script bash ne marche que sous un environnement UNIX.

## Installation

Il faut récupérer l'ensemble du projet sur votre poste 

```
git clone https://github.com/thomaroger/wGetCrawler.git
```

## Utilisation

Vous devez lancer en ligne de commande le script crawl.sh

```
./crawl.sh http://cv.thomaroger.fr
./crawl.sh http://cv.thomaroger.fr -v
```

### Arguments

- argument 1 : host détermine la première page qu'on va crawler
- argument 2 : verbes permet d'avoir des lots (Optionnel)

### Fonctionnement

Ce script va d'abord récupérer le contenu de la page web lié à l'adresse donnée grâce à l'argument 1. Il va d'abord récupérer les informations de celle-ci comme le title, le meta keyword, le meta description, les h1, les h2, les h3, les h4, les h5, les h6 et les textes de liens. Ensuite il va récupérer tous les liens de la page et va récupérer le contenu de chaque lien. Pour ce nouveau contenu, il va faire la même chose, il va récupérer les informations de la page et ensuite récupérer les liens et ainsi de suite...

### Sortie Standard

Ce script va afficher les liens externes et internes.

```
 ./crawl.sh http://cv.thomaroger.fr
Externals links for http://cv.thomaroger.fr : 
https://github.com/thomaroger
http://www.thomaroger.fr
Internals links for http://cv.thomaroger.fr :
http://cv.thomaroger.fr
http://cv.thomaroger.fr/
http://cv.thomaroger.fr/experiences
http://cv.thomaroger.fr/skills
http://cv.thomaroger.fr/training
http://cv.thomaroger.fr/others
http://cv.thomaroger.fr/contact
http://cv.thomaroger.fr#Programmation
http://cv.thomaroger.fr#Bases
http://cv.thomaroger.frde
http://cv.thomaroger.frdonnées
http://cv.thomaroger.fr#Javascript
http://cv.thomaroger.fr#Gestionnaire
http://cv.thomaroger.frfichiers
http://cv.thomaroger.fr#Modélisation
http://cv.thomaroger.fr#Méthodes
executed time : 16 seconds
```

## Export des données

Un fichier texte sera créer avec à l'intérieur les informations des pages crawlées comme le titre, le meta keyword, le meta description, les h1, etc.

```
URL : http://cv.thomaroger.fr
TITRE : Thomas ROGER
KEYWORDS : 
DESCRIPTION : 
H1 : 
H2 : 
H3 : Dernière expérience | Liste des compétences actuellement utilisées | Dernière formation |
H4 : 
H5 : Développeur Référent, e-TF1 | INSIA : Institut supérieur d'informatique appliqué |
H6 : 
TEXTE DE LIEN : Thomas ROGER : CV | Expériences | Compétences | Formations | Loisirs | contact | Github | Expériences | Compétences | Formations | Loisirs | thomaroger.fr |

...
```

