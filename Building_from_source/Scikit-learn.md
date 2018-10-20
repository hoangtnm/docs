# Build Scikit-learn from source

###  Prerequisites

- Python (>= 2.7 or >= 3.4)

- NumPy (>= 1.8.2)

- SciPy (>= 0.13.3)

- pandas

- Cython >=0.23

### Clone the Scikit-learn repository

```
export SKLEARN=/home/$USER/workspace/prebuilt_libraries/numpy
git clone git://github.com/scikit-learn/scikit-learn.git $SKLEARN
```

If you want to build a stable version, you can git checkout <VERSION> to get the code for that particular version

If you run the development version, it is cumbersome to reinstall the package each time you update the sources.

Therefore it’s recommended that you install in editable, which allows you to edit the code in-place.

This builds the extension in place and creates a link to the development directory

```
pip install --editable .
```
