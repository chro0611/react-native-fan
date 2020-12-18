import React, { useEffect } from 'react';
import { StyleSheet, View, Button } from 'react-native';
import { Fan } from 'react-native-fan';

export default function App() {

  const showAd = async () => {
    console.log(await(Fan.isLoad()));

    Fan.showAd().then(result=>{
        console.log("result====>", result);
        Fan.loadAd('737014050218983_737022993551422');
    }).catch(error=>{
      console.log("error===>",error);
    });
  }

  useEffect(() => {
    Fan.loadAd('270990974330870_285253309571303').then(message=>{
      console.log(message);
    }).catch(error=>{
      console.log(error);
    });
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
