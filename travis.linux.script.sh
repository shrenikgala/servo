set -e
cd build
../configure
export DISPLAY=:1.0
export RUST_TEST_TASKS=1
make tidy
make -j2
make check-servo
make check-content
make check-ref-cpu

mv x86_64-unknown-linux-gnu/rust_snapshot/rust-*/doc .
cp ../src/etc/doc.servo.org/* doc
make doc

if [ $TRAVIS_BRANCH = master ] && [ $TRAVIS_PULL_REQUEST = false ]
then
    echo '<meta http-equiv=refresh content=0;url=servo/index.html>' > doc/index.html
    sudo pip install ghp-import
    ghp-import -n doc
    git push -fq https://${TOKEN}@github.com/doc.servo.org.git gh-pages
fi