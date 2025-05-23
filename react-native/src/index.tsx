import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-perch-eye' doesn't seem to be linked. Make sure:\n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const PerchEye = NativeModules.PerchEyeModule
  ? NativeModules.PerchEyeModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function init(): Promise<void> {
  return PerchEye.init();
}

export function destroy(): Promise<void> {
  return PerchEye.destroy();
}

export function openTransaction(): Promise<void> {
  return PerchEye.openTransaction();
}

export function addImage(base64: string): Promise<string> {
  return PerchEye.addImage({ img: base64 });
}

export function enroll(): Promise<string> {
  return PerchEye.enroll();
}

export function verify(hash: string): Promise<number> {
  return PerchEye.verify({ hash });
}

export function evaluate(images: string[]): Promise<string> {
  return PerchEye.evaluate({ images });
}

export function compareList(images: string[], hash: string): Promise<number> {
  return PerchEye.compareList({ images, hash });
}

export function compareFaces(img1: string, img2: string): Promise<number> {
  return PerchEye.compareFaces({ img1, img2 });
}
