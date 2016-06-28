# bm.docker.php7
Docker for php7


This image can run both php-fpm and php cli for consumers.

By default it will start php-fpm and listen on port 9000.


If you want to run a consumer/worker it can be started linke this:

docker run -d bm.docker.php7 php app/console sqs:multiple-consumer --env=prod -q <consumername>

Each worker/consumer must run in its own container and the process must stay in foreground (ie. should not deamonize)
