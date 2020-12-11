import { NativeModules } from 'react-native';

type FanType = {
  isLoad() : Promise<boolean>;
  loadAd(placementId : String) : Promise<boolean>;
  showAd() : Promise<boolean>;
};

const Fan = NativeModules.Fan as FanType;

export {
  Fan
};
