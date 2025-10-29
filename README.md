# BastAir - Gestion d'Aéroclub

A faire :
Ce projet est une application web conçue pour la gestion complète d'un aéroclub. L'objectif est de fournir un site réactif avec une interface agréable, incluant des photos et des vidéos.

- construire les BDD (create)
## Fonctionnalités prévues

- faire les migrations
### Partie Publique

- frontend
Le site disposera d'une section accessible à tous les visiteurs, offrant :
-   **Informations sur l'aéroclub** : Présentation du club, de sa flotte, etc.
-   **Baptêmes de l'air** : Possibilité d'acheter des vols d'initiation.
-   **Contact** : Un formulaire pour contacter l'aéroclub.
-   **Commentaires** : Une section où les visiteurs peuvent laisser des avis.
-   **Outils** : Accès à divers outils utiles (météo, etc.).
-   **Informations BIA** : Détails sur le Brevet d'Initiation Aéronautique (dates, fonctionnement, banque de QCM pour l'entraînement).

### Partie Privée (Espace Adhérents)

Un espace sécurisé par identifiants pour les membres du club, avec les fonctionnalités suivantes :
-   **Agenda du club** : Réservation d'avions, inscription aux événements (pots, journées portes ouvertes).
-   **Gestion de la maintenance** : Suivi des opérations de maintenance sur les avions.
-   **Suivi des qualifications** : Gestion des dates de validité des qualifications des pilotes.
-   **Documents** : Accès à des documents réservés aux membres.
-   **Emailing** : Envoi d'informations et de newsletters aux membres.
-   **E-learning** : Accès à des cours en ligne.
-   **Comptabilité** : Outils pour la gestion comptable du club.
-   **Votes en ligne** : Participation aux votes des assemblées générales par internet.

### Backend

FONCTIONNALITES :
L'administration du site permettra de gérer l'ensemble des fonctionnalités de la partie privée (agenda, comptabilité, suivi des dates de validité, etc.).

Utilisation d'un compte Google (acb.bastair@gmail.com) pour stockage des données dans Drive, pour la gestion des Agendas et des Spreadsheets.

En frontend, un site avec :
## Démarrage du projet

- une partie publique :
   - informations sur l'aéroclub
   - possibilités d'acheter un baptêmes
   - contacter l'aéroclub
   - mettre un commentaire
   - accéder à des outils
   - informations sur le BIA (dates, fonctionnement, banque de données de tests QCM pour s'entraîner)
Pour lancer l'application en environnement de développement :

- une partie privée : pour les adhérents, avec des identifiants :
   - accès à l'agenda du club (réservation avion, évènements : pots, journées portes ouvertes,...)
   - gestion de la maintenance avions
   - gestions des dates de validité des qualifications des pilotes
   - accès à des documents
   - emailing d'information
   - accès à des cours en e-learning
   - gestion comptable du club (remplissage de feuille excel)
   - votes des assemblées générales par internet
1.  **Installer les dépendances :**
    ```bash
    bundle install
    ```

En backend, gestion de toute la partie privée (agenda, comptabilité, suivi des dates de validité,...)
2.  **Créer la base de données :**
    ```bash
    rails db:create
    ```

Un site réactif avec de belles pages en frontend, accès à des photos et vidéos.
3.  **Lancer les migrations :**
    ```bash
    rails db:migrate
    ```

4.  **(Optionnel) Remplir la base de données avec des données de test :**
    ```bash
    rails db:seed
    ```

5.  **Lancer le serveur :**
    ```bash
    rails server
    ```

6.  **Lancer les tâches planifiées de contrôle (dates et solde) :**
    Pour vérifier manuellement les dates de validité des qualifications des pilotes, on eput faire :
    ```bash
    rails validity:check_and_notify
    ```

### Déploiement des tâches planifiées avec Whenever

Pour que la tâche de vérification des validités s'exécute automatiquement tous les jours en production, le projet utilise la gem `whenever`.

1.  **Mettre à jour la crontab :**
    Depuis le répertoire de votre application en production, lancez la commande suivante pour mettre à jour la table cron du serveur :
    ```bash
    bundle exec whenever --update-crontab
    ```
