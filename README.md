# ![android-sex-size](art/logo.png)

# android-sex-size [![Build Status](https://travis-ci.org/dtboy1995/android-sex-size.svg?branch=master)](https://travis-ci.org/dtboy1995/android-sex-size)
:triangular_ruler: a nodejs tool for Android screen adaptation

# install

> npm install android-sex-size --global

# usage

### config template
- `adaptive` --template
- will generate `config.json`
```json
{
    "base": "360*640",
    "source": "[PROJECT_LOCATION]/app/src/main/res/values/dimens.xml",
    "targets": [
      "411*731",
      "360*720",
      "533*853"
    ],
    "output": "[PROJECT_LOCATION]/app/src/main/res"
}
```

### run with config.json
- `adaptive` --config config.json

### sample usage
- `adaptive` --sample
- `adaptive` -b 360\*640 -s dimens.xml -t 533\*853 -o .

### source xml sample
- source `360`*`640`
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="title_width">80dp</dimen>
</resources>
```
- target `533`*`853`
- run `adaptive` -s ./sample/dimens.xml -t 533*853 -o .
- will get **values-sw533dp\dimens.xml**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="title_width">118.4dp</dimen>
</resources>
```

# others

- :four_leaf_clover: [gets the app screen parameters](apps/measure.apk)
- :cactus: [screen size snippets](snippets.md)
