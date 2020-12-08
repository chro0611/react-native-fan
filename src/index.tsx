import { NativeModules } from 'react-native';

type FanType = {
  initialized(placementId : String) : void;
  isLoad() : Promise<boolean>;
  loadAd() : Promise<boolean>;
  showAd() : Promise<boolean>;
};

const Fan = NativeModules.Fan as FanType;

export {
  Fan
};
