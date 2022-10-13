import type { HostComponent, NativeSyntheticEvent, ViewProps } from 'react-native';

export interface NativeTurboProps extends ViewProps {
  url: string;
  sessionKey: string;
  onProposeVisit: (proposal: NativeSyntheticEvent<VisitProposal>) => void;
}

export interface TurboProps extends NativeTurboProps {  
  navigation: any;  
}

export interface TurboCommands {
  viewDidAppear: () => void;
}

export type NativeTurboViewType = HostComponent<NativeTurboProps> & TurboCommands;

export interface VisitProposal {
  url: string;
}
