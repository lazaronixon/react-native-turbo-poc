import React, { forwardRef, useEffect, useImperativeHandle, useRef } from 'react';
import { requireNativeComponent } from 'react-native';

import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

import type { NativeTurboProps, TurboCommands, TurboProps } from './types';

export const Commands = codegenNativeCommands({
  supportedCommands: ['viewDidAppear'],
});

const NativeTurboView = requireNativeComponent<NativeTurboProps>('TurboView');

export const TurboView = forwardRef(({ url, sessionKey, navigation, onProposeVisit, style }: TurboProps, ref) => {
  const turboViewRef = useRef<TurboCommands | null>(null);

  useEffect(() => {
    //TODO turboViewRef.current.viewWillAppear();

    const unsubscribe = navigation.addListener('focus', () => {
      //TODO turboViewRef.current.viewDidAppear();
    });

    return unsubscribe;
  }, [navigation]);

  useImperativeHandle(ref, () => ({
    viewDidAppear: () => Commands.viewDidAppear()
  }), [turboViewRef]);

  return (
    <NativeTurboView
      ref={turboViewRef}
      style={style}
      url={url}
      sessionKey={sessionKey}
      onProposeVisit={onProposeVisit}
    />
  );
})
