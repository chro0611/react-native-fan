# Facebook Audience Network(전면 광고)

페이스북 오디언스 네트워크 API의 라이프사이클은 광고 초기화(initialize) → 광고 로드(loadAd) → 광고가 정상적으로 로드 되었는지 확인(isLoad) → 광고 재생(showAd) → 다시 광고 로드(loadAd) 식으로 반복된다. showAd와 loadAd는 비동기로 호출되기 때문에 loadAd 호출 이후 비동기 대기(await)한 이후 showAd를 호출하거나, isLoad로 광고가 로드되었는지 확인한 이후 로드가 정상적으로 되었을때만 showAd를 호출하는 식의 기법이 필요하다

# Example

```jsx
import * as React from 'react';
import { StyleSheet, View, Text, Button } from 'react-native';
import Fan from 'react-native-fan';

export default function App() {

  const showAd = () => {
    if(Fan.isLoad())
    {
       Fan.showAd().then(result=>{
            console.log(result)
            Fan.loadAd()
       })
    }else
    {
      console.log("not loaded")
    }
  }

  React.useEffect(() => {
    Fan.initialized('737014050218983_737022993551422');
    Fan.loadAd()
  }, []);

  return (
    <View style={styles.container}>
      <Button onPress={showAd} title={"test"} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
```

# Reference

## methods

```jsx
initialized(placementId : String) : void
```

광고 초기화. placementid를 통해 광고를 초기화 시킨다

```jsx
isLoad() : boolean
```

광고가 로드되었는지 확인하는 함수

```jsx
loadAd() : Promise<boolean>
```

광고를 로드하는 함수. 정상적으로 로드되었을때 비동기로 true를 반환한다. 오류 발생시에는 catch를 통해 오류 내용을 확인할 수 있다.

```jsx
showAd() : Promise<boolean>
```

광고를 실제로 보여주는 함수. 비동기로 사용자가 광고를 클릭했는지 여부를 확인한다. 광고가 로드되지 않은 상태에서 호출시 에러가 발생하므로 반드시 광고가 로드되었는지 확인 후 호출하여아 한다
