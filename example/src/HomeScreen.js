/* eslint-disable react-native/no-inline-styles */

import * as React from 'react';
import { TurboView } from 'react-native-turbo';

export function HomeScreen({ route, navigation }) {
  return (
    <TurboView
      style={{ flex: 1 }}
      url={route.params.url}
      sessionKey="home"
      navigation={navigation}
      onProposeVisit={(event) => {
        navigation.push('Home', { url: event.nativeEvent.url });
      }}
    />
  );
}
