import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, LabeledList, Knob, Input, Section, Grid, Box, ProgressBar, Slider, AnimatedNumber } from '../components';
import { refocusLayout, Window } from '../layouts';
import { Table } from '../components/Table';

export const HelmConsole = (props, context) => {
  const { act, data, config } = useBackend(context);
  const { canFly, mapRef } = data;
  return (
    <Window resizable>
      <div className="CameraConsole__left">
        <Window.Content>
          {!!true && (
            <ShipControlContent />
          )}
          {!!true && (
            <ShipContent />
          )}
          <SharedContent />
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

const SharedContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { shipInfo = [], otherInfo = [] } = data;
  return (
    <Fragment>
      <Section title={shipInfo.name ? shipInfo.name : "Ship Info"}>
        <LabeledList>
          <LabeledList.Item label="Integrity">
            <ProgressBar
              ranges={{
                good: [51, 100],
                average: [26, 50],
                bad: [0, 25],
              }}
              maxValue={100}
              value={shipInfo.integrity} />
          </LabeledList.Item>
          <LabeledList.Item label="Sensor Range">
            <Slider
              value={shipInfo.sensor_range}
              minValue={1}
              maxValue={12}
              onChange={value => act('change_sensor_range', {
                sensor_range: value,
              })} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Radar"
        buttons={(
          <Button
            content="Refresh"
            onClick={() => act('refresh')} />
        )}>
        <Table>
          <Table.Row bold>
            <Table.Cell>
              Name
            </Table.Cell>
            <Table.Cell>
              Integrity
            </Table.Cell>
            <Table.Cell>
              Action
            </Table.Cell>
          </Table.Row>
          {otherInfo.map(ship => (
            <Table.Row key={ship.name}>
              <Table.Cell>
                {ship.name}
              </Table.Cell>
              <Table.Cell>
                {!!ship.integrity && (
                  <ProgressBar
                    ranges={{
                      good: [51, 100],
                      average: [26, 50],
                      bad: [0, 25],
                    }}
                    maxValue={100}
                    value={ship.integrity} />
                )}
              </Table.Cell>
              <Table.Cell>
                <Button icon="circle" />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Fragment>
  );
};

// Content included on helms when they're controlling ships
const ShipContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { speed, heading, eta, x, y } = data;
  return (
    <Section title="Velocity">
      <LabeledList>
        <LabeledList.Item label="Speed">
          <ProgressBar
            ranges={{
              good: [0, 4],
              average: [5, 6],
              bad: [7, Infinity],
            }}
            maxValue={10}
            value={speed}>
            <AnimatedNumber value={speed} />
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Heading">
          <AnimatedNumber value={heading} />
        </LabeledList.Item>
        <LabeledList.Item label="Position">
          X
          <AnimatedNumber value={x} />
          /Y
          <AnimatedNumber value={y} />
        </LabeledList.Item>
        <LabeledList.Item label="Next">
          <AnimatedNumber value={eta} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

// Arrow directional controls
const ShipControlContent = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section title="Navigation">
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
    </Section>
  );
};
