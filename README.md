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
### indolent
- `indolent` ./layout.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="200dp"
    android:layout_height="100dp"
    android:orientation="vertical">
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:textColor="@color/black_light"
        android:textSize="15sp" />
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:textColor="@color/black_light"
        android:textSize="20sp" />
</LinearLayout>
```
- will generated
- `out.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout
  xmlns:android="http://schemas.android.com/apk/res/android"  android:layout_width="@dimens/z66e175cf3015415aab1903f7970aad3e"       android:layout_height="@dimens/z62a8f9f7528642cc95276e77e3bde81f"
  android:orientation="vertical">
    <TextView
      android:layout_width="wrap_content"
      android:layout_height="wrap_content"
      android:textColor="@color/black_light"
      android:textSize="@dimens/z2042775670b242e0b9092da4aeec3137"/>
    <TextView
      android:layout_width="wrap_content"
      android:layout_height="wrap_content"
      android:textColor="@color/black_light"
      android:textSize="@dimens/z1b717b1d605648638dc46f841074ae1f"/>
</LinearLayout>
```
- `dimens.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <dimen name="z66e175cf3015415aab1903f7970aad3e">200dp</dimen>
  <dimen name="z62a8f9f7528642cc95276e77e3bde81f">100dp</dimen>
  <dimen name="z2042775670b242e0b9092da4aeec3137">15sp</dimen>
  <dimen name="z1b717b1d605648638dc46f841074ae1f">20sp</dimen>
</resources>
```

# others

- :four_leaf_clover: [gets the app screen parameters](apps/measure.apk)
- :cactus: [screen size snippets](snippets.md)
