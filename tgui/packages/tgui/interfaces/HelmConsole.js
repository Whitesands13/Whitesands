import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, LabeledList, Knob, Input, Section, Grid, Box, ProgressBar, Slider, AnimatedNumber } from '../components';
import { refocusLayout, Window } from '../layouts';
import { LabeledListItem } from '../components/LabeledList';

export const HelmConsole = (props, context) => {
  const { act, data, config } = useBackend(context);
  const { mapRef, speed, heading } = data;
  return (
    <Window resizable>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <Section title="Navigation">
            <HelmConsoleContent />
          </Section>
          <Section title="Velocity">
            <LabeledList>
              <LabeledList.Item label="Speed">
                <Slider
                  ranges={{
                    good: [0, 4],
                    average: [5, 6],
                    bad: [7, 10],
                  }}
                  minValue={0}
                  maxValue={10}
                  value={speed}
                  onChange={(e, value) => act('speed_change', {
                    newspeed: value,
                  })} />
              </LabeledList.Item>
              <LabeledList.Item label="Heading">
                <AnimatedNumber value={heading} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <ByondUi
          className="HelmConsole__map"
          params={{
            id: mapRef,
            parent: config.window,
            type: 'map',
          }} />
      </div>
    </Window>
  );
};

export const HelmConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Grid width="1px">
      <Grid.Column>
        <Button
          fluid
          icon="arrow-left"
          iconRotation={45}
          mb={1}
          onClick={() => act('change_heading', {
            dir: 9,
          })} />
        <Button
          fluid
          icon="arrow-left"
          mb={1}
          onClick={() => act('change_heading', {
            dir: 8,
          })} />
        <Button
          fluid
          icon="arrow-down"
          iconRotation={45}
          mb={1}
          onClick={() => act('change_heading', {
            dir: 10,
          })} />
      </Grid.Column>
      <Grid.Column>
        <Button
          fluid
          icon="arrow-up"
          mb={1}
          onClick={() => act('change_heading', {
            dir: 1,
          })} />
        <Button
          fluid
          icon="circle"
          mb={1}
          disabled={data.stopped}
          onClick={() => act('stop')} />
        <Button
          fluid
          icon="arrow-down"
          mb={1}
          onClick={() => act('change_heading', {
            dir: 2,
          })} />
      </Grid.Column>
      <Grid.Column>
        <Button
          fluid
          icon="arrow-up"
          iconRotation={45}
          mb={1}
          onClick={() => act('change_heading', {
            dir: 5,
          })} />
        <Button
          fluid
          icon="arrow-right"
          mb={1}
          onClick={() => act('change_heading', {
            dir: 4,
          })} />
        <Button
          fluid
          icon="arrow-right"
          iconRotation={45}
          mb={1}
          onClick={() => act('change_heading', {
            dir: 6,
          })} />
      </Grid.Column>
    </Grid>
  );
};
