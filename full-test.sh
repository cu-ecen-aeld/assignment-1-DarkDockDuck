#!/bin/bash
set -e
cd `dirname $0`
test_dir=`pwd`
echo "starting test with SKIP_BUILD=\"${SKIP_BUILD}\" and DO_VALIDATE=\"${DO_VALIDATE}\""

logfile=test.sh.log

# Function to cleanup and exit
cleanup_and_exit() {
    local exit_code=$1
    echo "Script execution completed."
    
    # Kill any remaining tee processes
    pkill -f "tee.*$logfile" 2>/dev/null || true
    
    # Wait a moment for processes to terminate
    sleep 1
    
    # Force exit
    exit $exit_code
}

# Trap to ensure cleanup on script termination
trap 'cleanup_and_exit $?' EXIT

# Simple logging without process substitution
{
    echo "Running test with user $(whoami)"
    set +e
    ./unit-test.sh
    unit_test_rc=$?
    if [ $unit_test_rc -ne 0 ]; then
        echo "Unit test failed"
    fi
    
    if [ -f conf/assignment.txt ]; then
        assignment=`cat conf/assignment.txt`
        if [ -f ./assignment-autotest/test/${assignment}/assignment-test.sh ]; then
            echo "Executing assignment test script"
            ./assignment-autotest/test/${assignment}/assignment-test.sh $test_dir
            rc=$?
            if [ $rc -eq 0 ]; then
                echo "Test of assignment ${assignment} complete with success"
            else
                echo "Test of assignment ${assignment} failed with rc=${rc}"
                cleanup_and_exit $rc
            fi
        else
            echo "No assignment-test script found for ${assignment}"
            cleanup_and_exit 1
        fi
    else
        echo "Missing conf/assignment.txt, no assignment to run"
        cleanup_and_exit 1
    fi
    
    # Ensure all output is flushed
    sync
    
    cleanup_and_exit ${unit_test_rc}
} | tee "$logfile"
