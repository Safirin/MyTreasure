Задача - Написать скрипт на bash для мониторинга процесса test в среде linux.

Скрипт должен отвечать следующим требованиям:

1) Запускаться при запуске системы (предпочтительно написать юнит systemd в дополнении к скрипту)
2) Отрабатывать кажду минуту
3) Если процесс запущен, то стучаться (по https) на https://test.com/monitoring.log (если процесс не запущен, то ничего не делать)
4) Если процесс перезапущен, писать в /var/log/monitoring.log (если процесс не запущен, то ничего не делать)
5) Если сервер мониторинга не доступен, так же писать в лог.

Значение и содержание файлов, необходмых для тестового задания:

 - PID_file - файл в котором записывается PID тестового процесса, созданного для мониторинга
 - README.txt - подробная инструкция, описывающая шаги по выполнению тестового задания
 - monitoring.log - файл в который записывается ответ, полученный с uri (в тестовом задании фигурирует https://test.com/monitoring.log)
 - testeffectmobile1.sh - bash скрипт который создает циклический процесс для мониторинга в среде Linux
 - testeffectmobile2.service - юнит systemd которые запускает bash скрипт testeffectmobile2.sh для мониторинга циклического процесса testeffectmobile1.sh
 - testeffectmobile2.sh - bash скрипт, которые выполняет находит циклический процесс, созданный testeffectmobile1

Решение:

Шаг 1. - Создание директории - mkdir /home/rinat/Interview
Шаг 2. - Создание циклического процесса для мониторинга в среде Linux.
  
  2.1 - создание файла
          mkdir /home/rinat/Interview/testeffectmobile1.sh

  2.2 - установить разрешение на запуск файла для всех пользователей
          chmod 777 /home/rinat/Interview/testeffectmobile1.sh

  2.3 - создание тестового циклического процесса в среде Linux, который будет выводить текст: "Knock, knock, knocking on https://test.com/monitoring/test/api door" строку в нулевое устройство каждые 60 секунд.
      - редактируем файл /home/rinat/Interview/testeffectmobile1.sh

          #!/bin/bash

          while true; do
	        echo "Knock, knock, knocking on https://test.com/monitoring/test/api door">/dev/null
	        sleep 60

          done

Шаг 3. - Создание циклического процесса testeffectmobile2.sh который будет мониторить тестовый процесс /home/rinat/Interview/testeffectmobile1.sh 

          #!/bin/bash

          while true; do #Создание циклического процесса, для того чтобы данный процесс "ловил" изменения у тестового процесса каждые 60 секунд.

          #Вводим переменные, необходимые для работы скрипта          

          PID_for_record="/home/rinat/Interview/PID_file" #Location of the PID id (Расположение файла, который будет отображать номер тестового процесса)
          monitoring_file="/home/rinat/Interview/monitoring.log" #Location of the monitring file (Расположение файла, который будет записывать ответ от сервера, к которому необходимо стучаться в случае запуска, перезапуска процесса)
          uri="http://kareliaminerhub.ru:80" #Uniform Resource Identifier (Унифицированный идентификатор ресурса, на который необходимо стучаться)
          date_of_event=$(date) #Time and Date of the process (Время и дата, в момент получения ответа от uri при отработке скрипта)


          current_PID=$(ps aux | grep '/bin/bash ./testeffectmobile1.sh' | grep -v grep | awk '{print $2}') #Finding the PID of the loop process (Находим PID циклического процесса)
          echo $current_PID "Current PID" #Observing the PID of the loop process (Выводим номер PID)
          previous_PID=$(tail -1 $PID_for_record) #Previous PID process (номер процесса записываем для того чтобы иметь возможность сравнить с номером нового процесса и создать соответсвующую запись в monnitoring.log)
          echo $previous_PID "Previous PID" #Observing the previous PID of the loop process

          #We need to rewrite the PID in case our process was reloaded (Сравниваем номер предыдущего процесса и текущего процесса и создаем соответсующую запись в файл)

          if [[ "$current_PID" != "$previous_PID" ]]; then

        	echo $current_PID $date_of_event "The process was reloaded">>$monitoring_file
	        echo $current_PID>$PID_for_record

          fi

          #If we do not have the active process in place, we do not need to send request to URI (Скрипт высылает запросы на uri в том случае если удается найти номер процесса PID)

          if [ "$current_PID" = "" ]; then
              echo "The Test process was not found"

          #If the process is active, we need to send the curl request to URI

          else reply_from_uri=$(curl -o /dev/null -s -w "%{http_code}\n" $uri) #We are recording the reply from URI

          fi

          #Depending on the reply from URI, we are making different notes in the log file. (В зависимости от ответа, полученного с uri, делаем различные записи в monitoring file)

          #The monitoring Server is not available (если uri не существует и приходит ответ "000", в этом случае записываем запись о том что мониторинговый сервер не доступен)

	        if [ "$reply_from_uri" = "000" ]; then
             	echo $reply_from_uri $date_of_event "The monitoring Server is not available">>$monitoring_file

          #The server was unable to locate or access the page or website. This issue originates from the site's end (Если у нас нет доступа к uri, делаем соответсвующую запись в monnitoring file)

 	        elif echo "$reply_from_uri" | grep -q "4[0-9][0-9]"; then
             	echo $reply_from_uri $date_of_event "The server was unable to locate or access the page or website. This issue originates from the site's end">>$monitoring_file

          #The client submitted a valid request, but the server was unable to fullfill it (если у нас возникает ошибка 500, делаем соответсвующую запись)

         	elif echo "$reply_from_uri" | grep -q "5[0-9][0-9]"; then
 	            echo $reply_from_uri $date_of_event "The client submitted a valid request, but the server was unable to fullfill it">>$monitoring_file

          fi

          sleep 60 #(Делаем процесс циклическим для того чтобы отслеживать процесс и его изменения)

          done


Шаг 4. - Создание сервиса в systemd, для того чтобы он автоматически запуск скрипт при инициализации системы - /etc/systemd/system/testeffectmobile2.sh





