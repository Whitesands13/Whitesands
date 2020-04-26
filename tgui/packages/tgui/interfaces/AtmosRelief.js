import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';

export const AtmosRelief = props => {
  const { act, data } = useBackend(props);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Open Pressure">
          <Button
            icon="pencil"
            content="Set"
            onClick={() => act(ref, "open_pressure", { "open_pressure": "input" })} />
          <Button
            icon="plus"
            content="Max"
            disabled={data.open_pressure === data.max_pressure}
            onClick={() => act(ref, "open_pressure", { "open_pressure": "max" })} />
          <span>
            <AnimatedNumber
              value={data.open_pressure}
              format={value => Math.round(value)} />
            {' '}
            kPa
          </span>
        </LabeledList.Item>
        <LabeledList.Item label="Close Pressure">
          <Button
            icon="pencil"
            content="Set"
            onClick={() => act(ref, "close_pressure", { "close_pressure": "input" })} />
          <Button
            icon="plus"
            content="Max"
            disabled={data.open_pressure === data.max_pressure}
            onClick={() => act(ref, "close_pressure", { "close_pressure": "open_pressure" })} />
          <span>
            <AnimatedNumber
              value={data.close_pressure}
              format={value => Math.round(value)} />
            {' '}
            kPa
          </span>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
