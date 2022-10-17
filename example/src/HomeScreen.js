/* eslint-disable react-native/no-inline-styles */

import React from 'react';
import { TurboView } from 'react-native-turbo';

export function HomeScreen({ route, navigation }) {
  return (
    <TurboView
      style={{ flex: 1 }}
      url={route.params.url}
      sessionKey="home"
      onProposeVisit={(event) => {
        navigation.push('Home', { url: event.nativeEvent.url });
      }}
    />
  );
}
