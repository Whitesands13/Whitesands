import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Button, LabeledList, ProgressBar, Section } from '../components';
import { BeakerContents } from './common/BeakerContents';

export const ClonePod = props => {
  const { act, data } = useBackend(props);

  return (
    <Section
      title="Beaker"
      buttons={(
        <Button
          icon="eject"
          disabled={!data.isBeakerLoaded}
          onClick={() => act('ejectbeaker')}
          content="Eject" />
      )}>
      <BeakerContents
        beakerLoaded={data.isBeakerLoaded}
        beakerContents={data.beakerContents} />
    </Section>
  );
};
