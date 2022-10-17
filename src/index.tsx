import React, { forwardRef, useImperativeHandle, useRef } from 'react';
import { requireNativeComponent } from 'react-native';

import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

import type { NativeTurboProps, TurboProps } from './types';

const NativeTurboView = requireNativeComponent<NativeTurboProps>('TurboView');

export const Commands = codegenNativeCommands({
  supportedCommands: ['viewWillAppear', 'viewDidAppear'],
});

export const TurboView = forwardRef<{}, TurboProps>(({ url, sessionKey, onProposeVisit, style }, ref) => {
  const turboViewRef = useRef(null);

  useImperativeHandle(ref, () => ({
    viewWillAppear: () => Commands.viewWillAppear(turboViewRef.current),
    viewDidAppear: () => Commands.viewDidAppear(turboViewRef.current)
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
