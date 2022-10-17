import React, { forwardRef, useImperativeHandle, useRef } from 'react';
import { requireNativeComponent } from 'react-native';

import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

import type { NativeTurboProps, TurboProps, TurboRef } from './types';

const NativeTurboView = requireNativeComponent<NativeTurboProps>('TurboView');

export const Commands = codegenNativeCommands({
  supportedCommands: ['reload'],
});

export const TurboView = forwardRef<TurboRef, TurboProps>(
  ({ url, sessionKey, onProposeVisit, style }, ref) => {
    const turboViewRef = useRef(null);

    useImperativeHandle(
      ref,
      () => ({
        reload: () => Commands.reload(turboViewRef.current),
      }),
      [turboViewRef]
    );

    return (
      <NativeTurboView
        ref={turboViewRef}
        style={style}
        url={url}
        sessionKey={sessionKey}
        onProposeVisit={onProposeVisit}
      />
    );
  }
);
