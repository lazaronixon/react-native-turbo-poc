import type { ViewProps, NativeSyntheticEvent } from 'react-native';

export interface NativeTurboProps extends ViewProps {
  url: string;
  sessionKey: string;
  onProposeVisit: (proposal: NativeSyntheticEvent<VisitProposal>) => void;
}

export interface TurboProps extends NativeTurboProps {}

export interface TurboRef {
  reload: () => void;
}

export interface VisitProposal {
  url: string;
}
