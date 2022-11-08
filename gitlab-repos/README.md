# Перенос репозиториев в gitlab и настройка пайплайнов

- Создать группу в gitlab astrviktor

- Перенастроить gitlab чтобы по умолчанию была ветка master
https://docs.gitlab.com/ee/user/project/repository/branches/default.html

http://158.160.38.135:8080/groups/astrviktor/-/settings/repository
Default branch - master

- Создать пустые репозитории для search_engine_crawler и search_engine_ui

https://github.com/express42/search_engine_crawler
https://github.com/express42/search_engine_ui

Склонировать пустые репозитории к себе, перенести в них код и запушить в gitlab

```
git clone http://158.160.38.135:8080/astrviktor/search_engine_crawler.git

копируем файлы из исходного репозитория, кроме .git

git add .
git commit -m "Initial commit"
git push -u origin master 
```

В итоге имеем клоны репозиториев в гитлабе, нужно добавить пайпланы теста и сборки
и пуша готового образа в репозиторий

```
Добавляем gitlab-ci.yml

Можно попробовать на основе 
https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Python.gitlab-ci.yml

git add .gitlab-ci.yml
git commit -m "Add CI"
git push 
```

Нужно добавить переменные для Docker Hub на группу в gitlab
https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-group