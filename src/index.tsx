import { NativeModules } from 'react-native';

type FanType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Fan } = NativeModules;

export default Fan as FanType;
