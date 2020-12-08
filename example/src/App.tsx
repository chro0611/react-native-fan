import React, { useEffect } from 'react';
import { StyleSheet, View, Button } from 'react-native';
import { Fan } from 'react-native-fan';

export default function App() {

  const showAd = async () => {
    console.log(await(Fan.isLoad()));

    Fan.showAd().then(result=>{
        console.log("result====>", result);
        Fan.loadAd();
    }).catch(error=>{
      console.log("error===>",error);
    });
  }

  useEffect(() => {
    Fan.initialized('270990974330870_285253309571303');
    Fan.loadAd();
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
