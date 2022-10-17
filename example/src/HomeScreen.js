/* eslint-disable react-native/no-inline-styles */

import React, { useEffect, useRef } from 'react';
import { TurboView } from 'react-native-turbo';

export function HomeScreen({ route, navigation }) {
  const turboViewRef = useRef(null);

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      turboViewRef.current.reload();
    });

    return unsubscribe;
  }, [navigation]);

  return (
    <TurboView
      ref={turboViewRef}
      style={{ flex: 1 }}
      url={route.params.url}
      sessionKey="home"
      onProposeVisit={(event) => {
        navigation.push('Home', { url: event.nativeEvent.url });
      }}
    />
  );
}
