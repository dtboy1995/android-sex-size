# android-sex-size [![Build Status](https://travis-ci.org/dtboy1995/android-sex-size.svg?branch=master)](https://travis-ci.org/dtboy1995/android-sex-size)
:iphone: a nodejs tool for Android screen adaptation

# install

> npm install android-sex-size --global

# usage

- config template
    - `adaptive --template`
```json
{
    "base": "360*640",
    "source": "[PROJECT_LOCATION]\\app\\src\\main\\res\\values\\dimens.xml",
    "targets": [
      "411*731",
      "360*720",
      "533*853"
    ],
    "output": "[PROJECT_LOCATION]\\app\\src\\main\\res"
}
```

- sample usage
  - `adaptive --sample`
```txt
 adaptive -b 360*640 -s dimens.xml -t 533*853 -o .
```

- source xml sample
  - prefix `w_` presents width unit
  - prefix `h_` presents height unit
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="w_title_width">80dp</dimen>
    <dimen name="h_title_height">44dp</dimen>
</resources>
```

# APP

:four_leaf_clover: [gets the app screen parameters](apps/measure.apk)
