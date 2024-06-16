set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

print "Starting the app 🏎️"

export TEST_URL=http://localhost:8080/photobook-demo/api/photobook/view/images/springio23/language/it/current_page/1/page_size/5
export LOOP_COUNT=250000
export BASE_DIR=target

java -XX:-UseJVMCICompiler -Xmx512m -jar ./${BASE_DIR}/springboot-photobook-*-SNAPSHOT.jar &
export PID=$!
psrecord $PID --plot "${BASE_DIR}/$(date +%s)-jit.png" --include-children &

sleep 5
print "Done waiting for startup..."

print "Executing warmup load"
hey -n=${LOOP_COUNT} -c=8 ${TEST_URL}

print "Executing benchmark load"
hey -n=${LOOP_COUNT} -c=8 ${TEST_URL}

print "JVM run done!🎉"
kill $PID
sleep 1
